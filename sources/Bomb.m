//
//  Bomb.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "Bomb.h"

@implementation Bomb

@synthesize gameObjectSprite;
@synthesize gameObjectSpeed;

- (id) init
{
    if( (self=[super init]) )
    {
        [self setGameObjectSpeed: 1];
        [self setGameObjectSprite:(@"Bomb.png")];
    }
    return (self);
}

- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Bomb is falling
    // from the top of the screen
    [self moveBy:ccp(0, -self.gameObjectSpeed)];
}

- (void) handleCollision
{
    
}
@end
