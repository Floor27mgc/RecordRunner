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
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (GameObjectBase *) injectObjectAt:(CGPoint)preferredLocation
         gameObjectType: (game_object_t)_gameObjectType
             effectType: (effect_type_t) _effectType
{
    Queue * usedPool;
    Queue * freePool;

    GameObjectBase * newObject = nil;
    int maxlimit;
    
    PATTERN_ALIGN_TO_GRID(preferredLocation);
    
    switch (_gameObjectType)
    {
        case BOMB_TYPE:
            usedPool = self.mainGameLayer.bombUsedPool;
            freePool = self.mainGameLayer.bombFreePool;
            maxlimit = MAX_NUM_BOMBS;
            break;
        case COIN_TYPE:
            usedPool = self.mainGameLayer.coinUsedPool;
            freePool = self.mainGameLayer.coinFreePool;
            maxlimit = MAX_NUM_COINS;
            break;
        case SPACE_TYPE:
            return nil;
    }
    
    
    if ([usedPool.objects count] < maxlimit) {
        newObject = [freePool takeObject];
        if (newObject != nil) {
            newObject.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
            [newObject moveTo:preferredLocation];
            newObject.gameObjectSprite.visible = 1;
            [usedPool addObject:newObject];
/*            CGPoint oldanchor = newObject.gameObjectSprite.anchorPoint;
            newObject.gameObjectSprite.anchorPoint=ccp(0.5,0.5);
            id actionToSmall = [CCScaleTo actionWithDuration: 1 scale:0.5f];
            id actionToNormal = [CCScaleTo actionWithDuration: 1 scale:1.5f];
            id action = [CCSequence actions:
                          actionToSmall,
                          actionToNormal,
                          nil ];
            [newObject.gameObjectSprite runAction:[CCRepeatForever actionWithAction:action]]; */
        } else {
            NSLog(@"out of object");
        }
        return newObject;
    }
    return nil;
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
            objCreated =
            [self injectObjectAt:currentLocation
                  gameObjectType:injectorPatternArray[_pattern_type][y][x]
                      effectType:kHeartPumping];
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
