//
//  Missile.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/18/13.
//
//

#import "GameLayer.h"
#import "Missile.h"

@implementation Missile
/*
@synthesize isHit = _isHit;

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        _isHit = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Bomb is rising
    // from the bottom of the screen
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER, self.radius,
                                             self.angleRotated)];
    self.angleRotated++;
    
    if ([self encounterWithPlayer]) {
        [self handleCollision];
    } else {
        /*CGSize windowSize = [[CCDirector sharedDirector] winSize];
        CGPoint curPoint = [self.gameObjectSprite position];
        
        if (curPoint.y > windowSize.height) {
            [self removeFromGamePool:[GameLayer sharedGameLayer].bombUsedPool];
        }*/
/*    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    //[self removeFromGamePool:[GameLayer sharedGameLayer].bombUsedPool];
    NSLog(@"Missle is hit -- Entering");
    _isHit = YES;
    
    [self resetObject];
    
    [[GameLayer sharedGameLayer] gameOver];
    
    [[GameLayer sharedGameLayer].score decrementScore:1000];
    
    NSLog(@"Missle is hit -- Exiting");
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}
*/
@end
