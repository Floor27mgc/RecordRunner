//
//  Coin.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "Coin.h"

@implementation Coin

//@synthesize gameObjectSprite;
//@synthesize gameObjectSpeed;

- (id) init
{
    if( (self=[super init]) )
    {
    }
    return (self);
}

- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Coin is falling
    // from the top of the screen
    [self moveBy:ccp(0, -self.gameObjectSpeed)];
}

- (BOOL) encounter
{
    return NO;
}

- (void) handleCollision
{
    
}
@end
