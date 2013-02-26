//
//  GameObjectInjector.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 12/11/12.
//
//

#import "GameObjectInjector.h"
#import "pattern.h"

@implementation GameObjectInjector

@synthesize mainGameLayer;
@synthesize lastObject;
@synthesize injectorHitBoxPath;
@synthesize dummyInjectorBox;
// -----------------------------------------------------------------------------------
+ (id) initWithGameLayer:(GameLayer *) gamelayer
{
    GameObjectInjector *objCreated;
    objCreated = [[self alloc] init];
    objCreated.mainGameLayer = gamelayer;
    objCreated.lastObject = gamelayer.player;

    return objCreated;
}

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self=[super init]) {
        // Add init stuff here for the base class
        injectorHitBoxPath = CGPathCreateMutable();
        
        CGPathMoveToPoint(injectorHitBoxPath,
                          NULL,
                          0,
                          (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(injectorHitBoxPath,
                             NULL,
                             PLAYER_RADIUS_OUTER_MOST,
                             (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(injectorHitBoxPath,
                             NULL,
                             PLAYER_RADIUS_OUTER_MOST,
                             -((COMMON_GRID_HEIGHT/2)));
        CGPathAddLineToPoint(injectorHitBoxPath,
                             NULL,
                             0,
                             -((COMMON_GRID_HEIGHT/2)));
        CGPathCloseSubpath(injectorHitBoxPath);
        dummyInjectorBox = [[CCNode alloc]init];
        dummyInjectorBox.position = COMMON_SCREEN_CENTER;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (GameObjectBase *) injectObjectToTrack: (int) trackNum
                                 atAngle: (int) insertionAngle
                          gameObjectType: (game_object_t)_gameObjectType
                              effectType: (effect_type_t) _effectType

{
    Queue * usedPool;
    Queue * freePool;

    GameObjectBase * newObject = nil;
    int maxlimit;
    
    CGPoint preferredLocation = ccp ((COMMON_SCREEN_CENTER_X +
                                      RADIUS_FROM_TRACKNUM(trackNum)*cos(CC_DEGREES_TO_RADIANS(insertionAngle))),
                                     (COMMON_SCREEN_CENTER_Y +
                                      RADIUS_FROM_TRACKNUM(trackNum)*sin(CC_DEGREES_TO_RADIANS(insertionAngle))));
    
    // If we happen to insert to where player is currently at,
    // we bails.
    dummyInjectorBox.rotation = insertionAngle;

    switch (_gameObjectType)
    {
        case BOMB_TYPE:
//            usedPool = self.mainGameLayer.bombUsedPool;
//            freePool = self.mainGameLayer.bombFreePool;
            maxlimit = (MIN_NUM_BOMBS_PER_TRACK * (trackNum + 1));
            break;
        case COIN_TYPE:
            usedPool = self.mainGameLayer.coinUsedPool;
            freePool = self.mainGameLayer.coinFreePool;
            maxlimit = (MIN_NUM_COINS_PER_TRACK * (trackNum + 1));
            break;
        case POWER_ICON_TYPE:
//            usedPool = self.mainGameLayer.powerIconUsedPool;
//            freePool = self.mainGameLayer.powerIconFreePool;
            maxlimit = (MIN_NUM_POWER_ICONS_PER_TRACK * (trackNum + 1));
            break;
        case SPACE_TYPE:
        case POWER_TYPE:
            return nil;
    }

    // Check to see if we can insert this one without overlapping
    for (int i=0; i<POOL_OBJ_COUNT_ON_TRACK(self.mainGameLayer.coinUsedPool, trackNum); i++)
    {
        NSMutableArray *currentObjectArray = POOL_OBJS_ON_TRACK(self.mainGameLayer.coinUsedPool, trackNum);
        CGPoint currentObjectPosition = ((GameObjectBase *)currentObjectArray[i]).gameObjectSprite.position;
        CGPoint gameObjectPoint = [dummyInjectorBox convertToNodeSpace: currentObjectPosition];
        CGPoint gameObjectPoint1 = CGPointMake(gameObjectPoint.x + COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y + COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint2 = CGPointMake(gameObjectPoint.x - COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y - COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint3 = CGPointMake(gameObjectPoint.x + COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y - COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint4 = CGPointMake(gameObjectPoint.x - COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y + COMMON_GRID_HEIGHT/2);

        
        if (CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint1,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint2,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint3,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint4,
                                true))
        {
            return nil;
        }        
    }

/*
    for (int i=0; i<POOL_OBJ_COUNT_ON_TRACK(self.mainGameLayer.bombUsedPool, trackNum); i++)
    {
        NSMutableArray *currentObjectArray = POOL_OBJS_ON_TRACK(self.mainGameLayer.bombUsedPool, trackNum);
        CGPoint currentObjectPosition = ((GameObjectBase *)currentObjectArray[i]).gameObjectSprite.position;
        CGPoint gameObjectPoint = [dummyInjectorBox convertToNodeSpace: currentObjectPosition];
        CGPoint gameObjectPoint1 = CGPointMake(gameObjectPoint.x + COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y + COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint2 = CGPointMake(gameObjectPoint.x - COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y - COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint3 = CGPointMake(gameObjectPoint.x + COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y - COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint4 = CGPointMake(gameObjectPoint.x - COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y + COMMON_GRID_HEIGHT/2);
        
        
        if (CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint1,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint2,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint3,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint4,
                                true))
        {
            return nil;
        }
    }

    for (int i=0; i<POOL_OBJ_COUNT_ON_TRACK(self.mainGameLayer.powerIconUsedPool, trackNum); i++)
    {
        NSMutableArray *currentObjectArray = POOL_OBJS_ON_TRACK(self.mainGameLayer.powerIconUsedPool, trackNum);
        CGPoint currentObjectPosition = ((GameObjectBase *)currentObjectArray[i]).gameObjectSprite.position;
        CGPoint gameObjectPoint = [dummyInjectorBox convertToNodeSpace: currentObjectPosition];
        CGPoint gameObjectPoint1 = CGPointMake(gameObjectPoint.x + COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y + COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint2 = CGPointMake(gameObjectPoint.x - COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y - COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint3 = CGPointMake(gameObjectPoint.x + COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y - COMMON_GRID_HEIGHT/2);
        CGPoint gameObjectPoint4 = CGPointMake(gameObjectPoint.x - COMMON_GRID_WIDTH/2,
                                               gameObjectPoint.y + COMMON_GRID_HEIGHT/2);
        
        
        if (CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint1,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint2,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint3,
                                true) ||
            CGPathContainsPoint(injectorHitBoxPath,
                                NULL,
                                gameObjectPoint4,
                                true))
        {
            return nil;
        }
    }
*/    
    newObject = [freePool takeObjectFromTrack:trackNum];
    if (newObject != nil) {
        newObject.anchorPoint = ccp(0.5,0.5);
        newObject.angleRotated = insertionAngle;
        newObject.radius = RADIUS_FROM_TRACKNUM(trackNum);
        [newObject moveTo:preferredLocation];
        newObject.visible = 1;
        [usedPool addObject:newObject toTrack:trackNum];
    } else {
        NSLog(@"out of object");
    }
    
    return newObject;
}

// -----------------------------------------------------------------------------------
- (void) injectObjectWithPattern:(pattern_type)_pattern_type
                initialXPosition: (CGPoint) _initialXPosition
{
    int y;
    int x;
    CGPoint currentLocation = CGPointMake(_initialXPosition.x,0);
    GameObjectBase *objCreated = nil;
    
    // if Last Object of this pattern has not been displayed yet,
    // then we bailed out and not going to inject any more objects
    if ([self isLastObjectOnScreen] == NO)
    {
        return;
    }
        
    for (y=0; y<PATTERN_NUM_ROWS; y++)
    {
        for (x = 0; x < PATTERN_NUM_COLS; x++)
        {
            currentLocation.x = currentLocation.x + COMMON_GRID_WIDTH;
            
            if (objCreated != nil)
            {
                lastObject = objCreated;
            }
        }
        currentLocation.x = _initialXPosition.x;
        currentLocation.y = currentLocation.y - COMMON_GRID_WIDTH;
    }

}

// -----------------------------------------------------------------------------------
- (bool) isLastObjectOnScreen
{
    return (((self.lastObject.gameObjectSprite.position.y > 0) ||
            (self.lastObject.gameObjectSprite.visible   == 0))?YES:NO);
}

@end
