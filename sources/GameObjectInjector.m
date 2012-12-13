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
// -----------------------------------------------------------------------------------
+ (id) initWithGameLayer:(GameLayer *) gamelayer
{
    GameObjectInjector *objCreated;
    objCreated = [[self alloc] init];
    objCreated.mainGameLayer = gamelayer;
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
- (void) injectObjectAt:(CGPoint)preferredLocation
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
            return;
    }
    
    
    if ([usedPool.objects count] < maxlimit) {
        newObject = [freePool takeObject];
        if (newObject != nil) {
            [newObject moveTo:preferredLocation];
            newObject.gameObjectSprite.visible = 1;
            [usedPool addObject:newObject];
        }
    }
}

// -----------------------------------------------------------------------------------
- (void) injectObjectWithPattern:(pattern_type)_pattern_type
                initialXPosition: (CGPoint) _initialXPosition
{
    int y;
    int x;
    CGPoint currentLocation = CGPointMake(_initialXPosition.x,0);
    
    for (y=0; y<PATTERN_NUM_ROWS; y++)
    {
        for (x = 0; x < PATTERN_NUM_COLS; x++)
        {
            [self injectObjectAt:currentLocation
                  gameObjectType:injectorPatternArray[_pattern_type][y][x]
                      effectType:kHeartPumping];
            currentLocation.x = currentLocation.x + INJECTOR_GRID_WIDTH;
        }
        currentLocation.y = currentLocation.y + INJECTOR_GRID_HEIGHT;
    }
}
@end
