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

@implementation Bomb
@synthesize gameObjectUpdateTick;
// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        gameObjectUpdateTick = 0;        
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
    if ([self encounterWithPlayer])
    {
        [self handleCollision];
    }
    else
    {
        //        [self recycleOffScreenObjWithUsedPool:[GameLayer sharedGameLayer].coinUsedPool
        //                                     freePool:[GameLayer sharedGameLayer].coinFreePool];
    }
    gameObjectUpdateTick++;
    
    // Determine if this Bomb has been obsolute.  If yes, we need to clear this
    // one out so the the user is not bored seeing the same bomb at the same place
    // over and over again.
    numRoundsRan = gameObjectUpdateTick / (360 / self.gameObjectAngularVelocity);
    if (numRoundsRan > BOMB_NUM_ROUNDS_BEFORE_RECYCLE) {
        [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].bombUsedPool
                               freePool:[GameLayer sharedGameLayer].bombFreePool];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].bombUsedPool
                           freePool:[GameLayer sharedGameLayer].bombFreePool];

    // if the player has a shield, act accordingly
    if ([GameLayer sharedGameLayer].player.hasShield) {
        NSLog(@"Bomb absorbed by player's shield!");
//        [[GameLayer sharedGameLayer].score incrementScore:2];
    } else {
        if ([GameLayer sharedGameLayer].gameOverLayer != nil)
        {
            CCBAnimationManager* animationManager =
                [GameLayer sharedGameLayer].gameOverLayer.userObject;
            NSLog(@"animationManager: %@", animationManager);

            [animationManager runAnimationsForSequenceNamed:@"Pop in"];
        } else {
            CCNode* gameOverLayer = [CCBReader nodeGraphFromFile:@"GameOverLayerBox.ccbi"];
            gameOverLayer.position = COMMON_SCREEN_CENTER;
            [[GameLayer sharedGameLayer] addChild:gameOverLayer z:11];
        }
        
        [[GameLayer sharedGameLayer] pauseSchedulerAndActions]; 

//        [[GameLayer sharedGameLayer] gameOver];
    
//        [[GameLayer sharedGameLayer].score decrementScore:1000];
    }
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
    gameObjectUpdateTick = 0;
}

@end
