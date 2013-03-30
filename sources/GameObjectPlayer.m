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
@implementation GameObjectPlayer
@synthesize direction;
@synthesize playerRadialSpeed;
@synthesize playerFacingAngle;
@synthesize hasShield;


// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    int track_num;
    if ([GameLayer sharedGameLayer].isDebugMode == YES)
        return;

    if ([[GameLayer sharedGameLayer] getIsHitStateByTrackNum:TRACKNUM_FROM_RADIUS] == YES)
    {
        [[[GameLayer sharedGameLayer] getHittingObjByTrackNum:TRACKNUM_FROM_RADIUS] handleCollision];
    }
    
    if (self.playerRadialSpeed == 0)
    {
        // Player is not moving.  Either it's in the inner most track
        // or in the outermost track
        self.angleRotated = self.angleRotated - self.gameObjectAngularVelocity;
        [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,self.radius,self.angleRotated)];
        self.rotation = self.angleRotated - (self.radius == PLAYER_RADIUS_INNER_MOST?0:180);
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

        [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
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
        direction = kMoveStill;
        self.radius = PLAYER_RADIUS_INNER_MOST;

        if ([GameInfoGlobal sharedGameInfoGlobal].gameMode == kGameModeRotatingPlayer) {
            self.gameObjectAngularVelocity = kDefaultGameObjectAngularVelocityInDegree;
        } else {
            self.gameObjectAngularVelocity = 0;
        }
        
        self.hasShield = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) setSheilded:(BOOL)trigger
{
    //[[GameLayer sharedGameLayer] removeChild:self.gameObjectSprite cleanup:YES];
    
    if (trigger) {
        hasShield = YES;
        //self.gameObjectSprite = [CCSprite spriteWithFile:@"player_with_shield.jpg"];
    } else {
        hasShield = NO;
        //self.gameObjectSprite = [CCSprite spriteWithFile:@"player-hd.png"];
    }
    
    //self.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
   // [[GameLayer sharedGameLayer] addChild:self.gameObjectSprite];
}

// -----------------------------------------------------------------------------------
- (void) changeDirection
{
    direction = (direction == kMoveInToOut) ? kMoveOutToIn : kMoveInToOut;
    self.playerRadialSpeed = kPlayerRadialSpeed;
}

- (void) onEnter
{
    // Setup a delegate method for the animationManager of the explosion
//    CCBAnimationManager* animationManager = self.userObject;
//    animationManager.delegate = self;
}
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    [GameLayer sharedGameLayer].isGameReadyToStart = TRUE;
}
@end
