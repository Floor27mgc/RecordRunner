//
//  Bomb.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "GameLayer.h"
#import "Bomb.h"
#import "CCBReader.h"
#import "GameInfoGlobal.h"

@implementation Bomb
@synthesize gameObjectUpdateTick;
@synthesize closeCallAbove;
@synthesize closeCallBelow;

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        gameObjectUpdateTick = 0;
        closeCallAbove = NO;
        closeCallBelow = NO;
        self.radiusHitBox = (COMMON_GRID_WIDTH/4);
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    int numRoundsRan = 0;
    // this is a negative movement down the Y-axis, the Coin is falling
    // from the top of the screen
    //[self moveBy:ccp(0, self.gameObjectSpeed)];
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_RECORD_CENTER,self.radius,self.angleRotated)];
    self.angleRotated = self.angleRotated + self.gameObjectAngularVelocity;
    gameObjectUpdateTick++;
    
    // Determine if this Bomb has been obsolute.  If yes, we need to clear this
    // one out so the the user is not bored seeing the same bomb at the same place
    // over and over again.
    numRoundsRan = gameObjectUpdateTick / (360 / self.gameObjectAngularVelocity);
    if (numRoundsRan > BOMB_NUM_ROUNDS_BEFORE_RECYCLE) {
        [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].bombUsedPool
                               freePool:[GameLayer sharedGameLayer].bombFreePool];
        return;
    }
    
    // if we do not hit the player now and the player is moving, see if we
    // have a "close call"
    if (![self encounterWithPlayer] &&
        ([GameLayer sharedGameLayer].player.playerRadialSpeed > 0)) {
        
        float distance = ccpDistance([GameLayer sharedGameLayer].player.position,
                                     self.position);
        
        // increment the score muliplier if we had a close call
        // But don't increment if the shield is active.
        if (abs(distance - self.radiusHitBox) < CLOSE_HIT_THRESHOLD_PIXEL &&
            ![GameLayer sharedGameLayer].player.hasShield) {
            
            // see if we are above or below the player
            int angleRelation = (int)self.angleRotated % 360;
            
            BOOL uniqueHit = NO;
            if (angleRelation > (360 - CLOSE_HIT_THRESHOLD_PIXEL)) {
                if (!closeCallAbove) {
                    closeCallAbove = YES;
                    uniqueHit = YES;
                }
            } else {
                if (!closeCallBelow) {
                    closeCallBelow = YES;
                    uniqueHit = YES;
                }
            }
            
            // only update multiplier and run animations if this is the first time
            // we've triggered the close call on this side
            if (uniqueHit) {
                [[GameLayer sharedGameLayer].multiplier incrementMultiplier:1];
                
                [GameInfoGlobal sharedGameInfoGlobal].closeCallsThisLife++;

                if ([GameLayer sharedGameLayer].player.direction == kMoveInToOut)
                {
                    
                   [self.animationManager runAnimationsForSequenceNamed:@"CounterClockWiseRotation"];
                }
                else 
                {
                    [self.animationManager runAnimationsForSequenceNamed:@"ClockWiseRotation"];
                }
            }
        }

        // reset close call flag when on other side of 
        if ((closeCallBelow || closeCallAbove) &&
            ((int)distance > 180 && (int)distance < 200)) {
            closeCallAbove = NO;
            closeCallBelow = NO;
        }
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    if ([GameLayer sharedGameLayer].isDebugMode == YES)
        return;
    
    [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].bombUsedPool
                           freePool:[GameLayer sharedGameLayer].bombFreePool];

    // if the player has a shield, act accordingly
    if ([GameLayer sharedGameLayer].player.hasShield) {
        [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:BOMB_STATS] tick];
        [GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield++;
        NSLog(@"Bomb absorbed by player's shield!");
    } else {
        // update end-of-game statistics
        [[[GameInfoGlobal sharedGameInfoGlobal] statsContainer] writeStats];
        
        if ([GameLayer sharedGameLayer].gameOverLayer != nil)
        {
            CCBAnimationManager* animationManager =
                [GameLayer sharedGameLayer].gameOverLayer.userObject;
            NSLog(@"animationManager: %@", animationManager);

            [animationManager runAnimationsForSequenceNamed:@"Pop in"];
        } else {
            GameOverLayer * gameOverLayer =
                (GameOverLayer *) [CCBReader nodeGraphFromFile:@"GameOverLayerBox.ccbi"];
            gameOverLayer.position = COMMON_SCREEN_CENTER;
            
            //This sets the menu data for the final menu
            [gameOverLayer setMenuData:
                [[GameLayer sharedGameLayer].multiplier getMultiplier]
                    finalScore:[[GameLayer sharedGameLayer].score getScore]
                        highScore:[[GameLayer sharedGameLayer].highScore getScore]];
            
            
            [[GameLayer sharedGameLayer] addChild:gameOverLayer z:11];
        }
        
        [[GameLayer sharedGameLayer] pauseSchedulerAndActions];
        
        [[[GameInfoGlobal sharedGameInfoGlobal] statsContainer] resetGameTimer];
    }
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
    gameObjectUpdateTick = 0;
}

@end
