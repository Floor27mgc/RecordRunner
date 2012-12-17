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
    // this is a negative movement down the Y-axis, the Bomb is rising
    // from the bottom of the screen
    [self moveBy:ccp(0, self.gameObjectSpeed)];
    
    if ([self encounterWithPlayer])
    {
        [self handleCollision];
    }
    else
    { 
        [self recycleOffScreenObjWithUsedPool:self.parentGameLayer.bombUsedPool
                                     freePool:self.parentGameLayer.bombFreePool];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    [self recycleObjectWithUsedPool:self.parentGameLayer.bombUsedPool
                           freePool:self.parentGameLayer.bombFreePool];
    
    // increment score
    [self.parentGameLayer.score decrementScore:100];
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}

@end
