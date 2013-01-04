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
    objCreated.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
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
    CCSprite * pSprite = self.parentGameLayer.player.gameObjectSprite;
    pSprite.anchorPoint = ccp(0.5,0.5);

    if (self.parentGameLayer.player.gameObjectSpeed == 0)
    {
        CGRect playerHitBox = CGRectMake(pSprite.position.x,
                                         pSprite.position.y,
                                         pSprite.boundingBox.size.width,
                                         pSprite.boundingBox.size.height);
        if ([self encounter:playerHitBox])
        {
            return YES;
        }
    }
    else
    {
        if ((pSprite.position.x > PLAYER_LEFT_BOUND) &&
            (self.parentGameLayer.player.direction == kMoveRight))
        {
            CGRect playerHitBox = CGRectMake(pSprite.position.x + kPlayerHitBoxSegmentWidth,
                                             pSprite.position.y,
                                             -kPlayerHitBoxSegmentWidth * 2,
                                             [pSprite boundingBox].size.height);
            if ([self encounter:playerHitBox])
            {
                return YES;
            }
        }
        
        if ((pSprite.position.x < PLAYER_RIGHT_BOUND) &&
            (self.parentGameLayer.player.direction == kMoveLeft))
        {
            CGRect playerHitBox = CGRectMake(pSprite.position.x,
                                             pSprite.position.y,
                                             2 * kPlayerHitBoxSegmentWidth,
                                             [pSprite boundingBox].size.height);
            if ([self encounter:playerHitBox])
            {
                return YES;
            }
        }
    }
    
    return NO;
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
    
    i = [_usedObjPool.objects indexOfObjectIdenticalTo:self];
    [[_usedObjPool.objects objectAtIndex:i] resetObject];
    
    [_freeObjPool addObject:[_usedObjPool.objects objectAtIndex:i]];
    [_usedObjPool.objects removeObjectAtIndex:i];

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
