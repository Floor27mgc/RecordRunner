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
@synthesize hadCloseCall;

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        gameObjectUpdateTick = 0;
        hadCloseCall = NO;
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
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,self.radius,self.angleRotated)];
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
    [self encounterWithPlayer];
    
    // detect a "close call" with a bomb
    float distance = ccpDistance([GameLayer sharedGameLayer].player.position,
                                 self.position);
    
    // increment the score muliplier if we had a close call
    // But don't increment if the shield is active.
    if (abs(distance - self.radiusHitBox) < CLOSE_HIT_THRESHOLD_PIXEL &&
        !hadCloseCall && ![GameLayer sharedGameLayer].player.hasShield) {
        [[GameLayer sharedGameLayer].multiplier incrementMultiplier:1];
        hadCloseCall = YES;
        
        [GameInfoGlobal sharedGameInfoGlobal].closeCalls++;

        if ([GameLayer sharedGameLayer].player.direction == kMoveInToOut)
        {
            
           [self.animationManager runAnimationsForSequenceNamed:@"CounterClockWiseRotation"];
        }
        else 
        {
            [self.animationManager runAnimationsForSequenceNamed:@"ClockWiseRotation"];
        }
    }

    // reset close call flag when on other side of 
    if (hadCloseCall && ((int)distance > 180 && (int)distance < 200)) {
        hadCloseCall = NO;
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
        
        // reset any per-game data tracking
        [[GameInfoGlobal sharedGameInfoGlobal] resetPerLifeStatistics];
        
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
