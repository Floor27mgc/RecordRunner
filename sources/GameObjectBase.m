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
@synthesize gameObjectAngularVelocity=_gameObjectAngularVelocity;
@synthesize parentGameLayer;
@synthesize radius;
@synthesize angleRotated;

// -----------------------------------------------------------------------------------
+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed
{
    GameObjectBase *objCreated;
    objCreated = [[self alloc] init];
    objCreated.parentGameLayer = gamelayer;
    objCreated.gameObjectSprite = [CCSprite spriteWithFile:fileName];
    objCreated.gameObjectAngularVelocity = speed;
    objCreated.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
    objCreated.angleRotated = 0;
    return objCreated;
}

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self=[super init]) {
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
    mySprite.anchorPoint = ccp(0.5, 0.5);
    CGRect myBox   =
    CGRectMake(mySprite.position.x,
                mySprite.position.y,
                [mySprite boundingBox].size.width *1.2,
                [mySprite boundingBox].size.height*1.2);
    return (CGRectIntersectsRect(box, myBox));
}

// -----------------------------------------------------------------------------------
- (BOOL) encounterWithPlayer
{

    // Convere the game object itself (bomb, coins..etc) to player's
    // node space for collision detection
    // Once converted, we will CGPathContainsPoint this node space coordinate with
    // the path to do a match.
    
    CGPoint gameObjectPoint = [self.parentGameLayer.player.gameObjectSprite convertToNodeSpace: self.gameObjectSprite.position];
    
    if (CGPathContainsPoint(self.parentGameLayer.player.playerBoundingPath,
                            NULL,
                            gameObjectPoint,
                            true))
    {
        return YES;
    }
    else
    {
        return NO;
    }

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
- (void) recycleOffScreenObjWithUsedPool:(Queue *)_usedObjPool
                                freePool:(Queue *)_freeObjPool
{
    CGSize windowSize      = [[CCDirector sharedDirector] winSize];

    CGPoint curPoint = [self.gameObjectSprite position];
    if (curPoint.y > windowSize.height) {
        [self recycleObjectWithUsedPool:_usedObjPool freePool:_freeObjPool];
    }
}

// -----------------------------------------------------------------------------------
- (void) recycleObjectWithUsedPool:(Queue *)_usedObjPool
                          freePool:(Queue *)_freeObjPool
{
    NSUInteger i;
    
    i = [POOL_OBJS_ON_TRACK(_usedObjPool, TRACKNUM_FROM_RADIUS) indexOfObjectIdenticalTo:self];
    
    [[POOL_OBJS_ON_TRACK(_usedObjPool, TRACKNUM_FROM_RADIUS) objectAtIndex:i] resetObject];
    
    [POOL_OBJS_ON_TRACK(_freeObjPool, TRACKNUM_FROM_RADIUS) addObject:[POOL_OBJS_ON_TRACK(_usedObjPool,TRACKNUM_FROM_RADIUS) objectAtIndex:i]];
    [POOL_OBJS_ON_TRACK(_usedObjPool, TRACKNUM_FROM_RADIUS) removeObjectAtIndex:i];

}

// -----------------------------------------------------------------------------------
- (void) removeFromGamePool:(Queue *)pool
{
    NSInteger i = [pool.objects indexOfObjectIdenticalTo:self];
    [[pool.objects objectAtIndex:i] resetObject];
    [pool.objects removeObjectAtIndex:i];
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    self.gameObjectSprite.position = ccp(0,0);
    self.gameObjectSprite.visible = 0;
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
- (void) showNextFrame
{
    
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    NSAssert(YES, @"Update method is missing in implementation of class %s",
             class_getName([self class]));
}
@end
