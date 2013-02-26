//
//  Bomb.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "GameLayer.h"
#import "Bomb.h"

@implementation Bomb
/*
// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
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
        //        [self recycleOffScreenObjWithUsedPool:self.parentGameLayer.coinUsedPool
        //                                     freePool:self.parentGameLayer.coinFreePool];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    [self recycleObjectWithUsedPool:self.parentGameLayer.bombUsedPool
                           freePool:self.parentGameLayer.bombFreePool];

    // if the player has a shield, act accordingly
    if (self.parentGameLayer.player.hasShield) {
        [self.parentGameLayer.score incrementScore:2];
    } else {
        [self.parentGameLayer gameOver];
    
        [self.parentGameLayer.score decrementScore:1000];
    }
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}
*/
@end
