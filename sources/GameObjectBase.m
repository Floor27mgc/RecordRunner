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
#import "common.h"
#import <objc/runtime.h>


@implementation GameObjectBase
@synthesize gameObjectAngularVelocity=_gameObjectAngularVelocity;
@synthesize radius;
@synthesize angleRotated;
@synthesize animationManager;


// -----------------------------------------------------------------------------------
+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed
{
    GameObjectBase *objCreated;
    objCreated = [[self alloc] init];
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
        animationManager = nil;
        self.radiusHitBox = (COMMON_GRID_WIDTH/2);
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
    GameLayer *gameLayer = [GameLayer sharedGameLayer];
    
    if (ccpDistance(gameLayer.player.position, self.position) < (self.radiusHitBox)) {
        [gameLayer setIsHitStateByTrackNum:TRACKNUM_FROM_RADIUS
                                   toState:YES];
        [gameLayer setHittingObjByTrackNum:TRACKNUM_FROM_RADIUS hittingObj:self];
        return YES;
    } else {
        return NO;
    }
}

// -----------------------------------------------------------------------------------
- (void) moveTo:(CGPoint) targetPoint
{
    [self setPosition: targetPoint];
}

// -----------------------------------------------------------------------------------
- (CGPoint) getGameObjectSpritePosition
{
    return self.position;
}

// -----------------------------------------------------------------------------------
- (void) moveBy:(CGPoint) relativePoint
{
    [self setPosition:ccp(_gameObjectSprite.position.x + relativePoint.x,
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
    id objectToRecyle;
    
    i = [POOL_OBJS_ON_TRACK(_usedObjPool, TRACKNUM_FROM_RADIUS) indexOfObjectIdenticalTo:self];
    
    objectToRecyle = [POOL_OBJS_ON_TRACK(_usedObjPool, TRACKNUM_FROM_RADIUS) objectAtIndex:i];
    [objectToRecyle resetObject];

    [_freeObjPool addObject:objectToRecyle toTrack:TRACKNUM_FROM_RADIUS];
    [_usedObjPool takeObjectFromIndex:i fromTrack:TRACKNUM_FROM_RADIUS];
}

// -----------------------------------------------------------------------------------
- (BOOL) removeFromGamePool:(Queue *)pool
{
    // find which track I'm on then remove myself
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        if ([pool contains:self onTrack:trackNum]) {
            [pool removeObjectFromTrack:trackNum withObject:self];
            return YES;
        }
    }
    return NO;
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    self.position = ccp(0,0);
    self.visible = 0;
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
    NSLog(@"in base clas");
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    NSAssert(YES, @"Update method is missing in implementation of class %s",
             class_getName([self class]));
}

// -----------------------------------------------------------------------------------
-(void) scaleMe:(double)factor
{
    if (factor < 0) {
        return;
    }
    
    double scaleFactor = factor+1;

    self.scaleX = scaleFactor;
    self.scaleY = scaleFactor;
}

// -----------------------------------------------------------------------------------
-(void) changeAngularVelocityByDegree:(float) byDegree
{
    if ((self.gameObjectAngularVelocity + byDegree) != 0.0f)
    {
        self.gameObjectAngularVelocity += byDegree;
    }
}

@end
