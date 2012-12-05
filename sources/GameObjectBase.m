//
//  GameObjectBase.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import "GameObjectBase.h"
#import "GameLayer.h"
#import "cocos2d.h"
#import <objc/runtime.h>


@implementation GameObjectBase
@synthesize gameObjectSpeed=_gameObjectSpeed;
@synthesize parentGameLayer;

// -----------------------------------------------------------------------------------
+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed
{
    GameObjectBase *objCreated;
    objCreated = [[self alloc] init];
    objCreated.parentGameLayer = gamelayer;
    objCreated.gameObjectSprite = [CCSprite spriteWithFile:fileName];
    objCreated.gameObjectSpeed = speed;
    return objCreated;
}

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        // Add init stuff here for the base class
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (CGRect) getObjectBound
{
    return (_gameObjectSprite.boundingBox);
}

// -----------------------------------------------------------------------------------
- (BOOL) encounter:(int) y
    withHeight:(int)height
{
    CGPoint curLocation = [self.gameObjectSprite position];
    int myHeight = [self.gameObjectSprite boundingBox].size.height;
        
    return ((curLocation.y + myHeight) >=
            (y + height));
}

// -----------------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------------
- (void) moveTo:(CGPoint) targetPoint
{
    [_gameObjectSprite setPosition: targetPoint];
}

// -----------------------------------------------------------------------------------
- (CGPoint) getGameObjectSpritePosition
{
    return _gameObjectSprite.position;
}

// -----------------------------------------------------------------------------------
- (void) moveBy:(CGPoint) relativePoint
{
    [_gameObjectSprite setPosition:ccp(_gameObjectSprite.position.x + relativePoint.x,
                                       _gameObjectSprite.position.y + relativePoint.y)];
}

// -----------------------------------------------------------------------------------
- (void) update: (ccTime) dt
{
    [self showNextFrame];
    if ([self encounter:0 withHeight:0])
    {
        [self handleCollision];
    }
}

// -----------------------------------------------------------------------------------
// "Virtual methods" that the derived class should implement.
// If not implemented, this method will be called and Assert game
- (void) showNextFrame
{
    //    NSAssert(YES, @"Update method is missing in implementation of class %s",
    //             class_getName([self class]));
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    NSAssert(YES, @"Update method is missing in implementation of class %s",
             class_getName([self class]));
}
@end
