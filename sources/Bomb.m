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
// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        gameObjectUpdateTick = 0;
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
            [gameOverLayer.finalScore setString:[NSString stringWithFormat:@"%d",
                                                 [[GameLayer sharedGameLayer].score getScore]]];
            
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
