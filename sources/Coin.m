//
//  Coin.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "Coin.h"

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
}

/*
- (BOOL) encounter:(CGRect) box
{
    CCSprite * mySprite  = self.gameObjectSprite;
    mySprite.anchorPoint = ccp(0, 0);
    CGRect myBox   =
    CGRectMake(mySprite.position.x,
               mySprite.position.y,
               [mySprite boundingBox].size.width,
               [mySprite boundingBox].size.height);
    
    return (CGRectIntersectsRect(box, myBox));
}

- (BOOL) encounter:(int) y
        withHeight:(int) height
{
    CGPoint curLocation = [self.gameObjectSprite position];
    int myHeight = [self.gameObjectSprite boundingBox].size.height;
        
    return ((curLocation.y + myHeight) >=
            (y + height));
}*/

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    
}
@end
