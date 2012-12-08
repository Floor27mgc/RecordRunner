//
//  Coin.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "Coin.h"
#import "GameLayer.h"
@implementation Coin

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
    [self moveBy:ccp(0, self.gameObjectSpeed)];
    
    if ([self encounterWithPlayer])
    {
        [self handleCollision];
    }
    else
    {
        [self recycleOffScreenObjWithUsedPool:self.parentGameLayer.coinUsedPool
                                     freePool:self.parentGameLayer.coinFreePool];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    [self recycleObjectWithUsedPool:self.parentGameLayer.coinUsedPool
                           freePool:self.parentGameLayer.coinFreePool];
    
    // increment score
    [[self parentGameLayer] incrementScore:1];
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    
}

@end
