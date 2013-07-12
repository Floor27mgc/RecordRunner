//
//  GameObjectPlayer.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import "GameObjectPlayer.h"
#import "GameLayer.h"
#import "common.h"
#import "GameObjectInjector.h"
#import "GameInfoGlobal.h"
#import "SoundController.h"

@implementation GameObjectPlayer
@synthesize direction;
@synthesize playerRadialSpeed;
@synthesize playerFacingAngle;
@synthesize hasShield;
@synthesize arrivedAtOuterTrack;


// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    int track_num;
/*    if ([GameLayer sharedGameLayer].isDebugMode == YES)
        return;*/

    if ([[GameLayer sharedGameLayer] getIsHitStateByTrackNum:TRACKNUM_FROM_RADIUS] == YES)
    {
        [[[GameLayer sharedGameLayer] getHittingObjByTrackNum:TRACKNUM_FROM_RADIUS] handleCollision];
    }
    
    if (self.playerRadialSpeed == 0)
    {
        // Player is not moving.  Either it's in the inner most track
        // or in the outermost track
        self.angleRotated = self.angleRotated - self.gameObjectAngularVelocity;
        [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_RECORD_CENTER,
                                                 self.radius, self.angleRotated)];
        self.rotation = self.angleRotated - (self.radius == PLAYER_RADIUS_INNER_MOST?0:180);
        
        // if player is on the outer track, increment the timer for tracking this
        if (self.radius == PLAYER_RADIUS_OUTER_MOST) {
            if (arrivedAtOuterTrack == [NSDate distantFuture]) {
                arrivedAtOuterTrack = [NSDate date];
            } else {
                int elapsed = [arrivedAtOuterTrack timeIntervalSinceNow];
                [GameInfoGlobal sharedGameInfoGlobal].timeInOuterRingThisLife += elapsed;
                arrivedAtOuterTrack = [NSDate date];
            }
            
        }
    }
    else
    {
        // Player is in motion.  Let's move the player
        self.radius = self.radius + (self.playerRadialSpeed * self.direction);
        
        if (self.radius > PLAYER_RADIUS_OUTER_MOST)
        {
            self.radius = PLAYER_RADIUS_OUTER_MOST;
        }
        
        if (self.radius < PLAYER_RADIUS_INNER_MOST)
        {
            self.radius = PLAYER_RADIUS_INNER_MOST;
        }

        [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_RECORD_CENTER,
                                                 self.radius,
                                                 self.angleRotated)];
        
        // The player has arrived the outer track or the center.  This
        // means the player will not need to move along radial direction anymore
        if ((self.radius == PLAYER_RADIUS_OUTER_MOST) ||
            (self.radius == PLAYER_RADIUS_INNER_MOST))
        {
            self.playerRadialSpeed = 0;
        }
    }
    
    // Reset the isHit array to prepare for the next frame comparison
    for (track_num = 0; track_num < MAX_NUM_TRACK; track_num++) {
        [[GameLayer sharedGameLayer] setIsHitStateByTrackNum:track_num toState:NO];
        [[GameLayer sharedGameLayer] setHittingObjByTrackNum:track_num hittingObj:nil];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    
}

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        //NSLog(@"init anim man: %p, user obj: %p", self.animationManager, self.userObject);
        direction = kMoveStill;
        self.radius = PLAYER_RADIUS_INNER_MOST;

        if ([GameInfoGlobal sharedGameInfoGlobal].gameMode == kGameModeRotatingPlayer) {
            self.gameObjectAngularVelocity = kDefaultGameObjectAngularVelocityInDegree;
        } else {
            self.gameObjectAngularVelocity = 0;
        }
        
        self.arrivedAtOuterTrack = [NSDate distantFuture];
        
        self.hasShield = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) setSheilded:(BOOL)trigger
{    
    if (trigger) {
        hasShield = YES;
    } else {
        hasShield = NO;
    }
}

// -----------------------------------------------------------------------------------
- (void) changeDirection
{
    [[SoundController sharedSoundController] playSoundIdx:SOUND_PLAYER_SWIPE fromObject:self];
    
    if ([GameLayer sharedGameLayer].isDebugMode == YES)
        return;
    direction = (direction == kMoveInToOut) ? kMoveOutToIn : kMoveInToOut;
    self.playerRadialSpeed = kPlayerRadialSpeed;
    
    // reset the outer track timer
    arrivedAtOuterTrack = [NSDate distantFuture];
}

// -----------------------------------------------------------------------------------
- (BOOL) willHitBomb
{
    Queue * bombTracks = [GameLayer sharedGameLayer].bombUsedPool;
    
    for (int i = 0; i < MAX_NUM_TRACK; ++i) {
        NSMutableArray * curTrack = [bombTracks getObjectArray:i];
        
        for (int j = 0; j < curTrack.count; ++j) {
            Bomb * thisBomb = [curTrack objectAtIndex:j];
        
            // "55" needs to be either 55 or 28 depending on hd or not
            if ([self spriteInPath:thisBomb.angleRotated withWidth:55]) {
                return YES;
            }
        }
    }
    
    return NO;
}

// -----------------------------------------------------------------------------------
- (BOOL) spriteInPath:(int)angle withWidth:(int)width
{
    // "55" needs to be 55 or 28 depending on whether hd or not
    int playerStartAngle = self.playerFacingAngle - (55 / 2);
    int playerEndAngle = self.playerFacingAngle + (55 / 2);
    
    // when player is near 360 segment
    if (playerStartAngle < 0) {
        playerStartAngle = 360 + playerStartAngle;
    }
    
    if ((angle > playerStartAngle || angle < playerEndAngle) ||
        (angle + (width / 2) > playerStartAngle) ||
        (angle - (width / 2) < playerEndAngle)) {
        return YES;
    }
    
    return NO;
}

// -----------------------------------------------------------------------------------
- (void) blink
{
    NSLog(@"animation manager: %p", self.animationManager);
    [self.animationManager runAnimationsForSequenceNamed:@"blink_player"];
}

// -----------------------------------------------------------------------------------
- (void) onEnter
{
    // Setup a delegate method for the animationManager of the explosion
//    CCBAnimationManager* animationManager = self.userObject;
//    animationManager.delegate = self;
}

//Called by the bomb object when handlecollision finds they ran into each other
- (void) killYourself
{
    [[SoundController sharedSoundController] playSoundIdx:SOUND_PLAYER_DIE fromObject:self];
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    [GameLayer sharedGameLayer].isGameReadyToStart = TRUE;
}
@end
