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
    int trackNum = 0;
    
    PATTERN_ALIGN_TO_GRID(preferredLocation);
    trackNum = (preferredLocation.x - COMMON_SCREEN_CENTER_X) / COMMON_GRID_WIDTH;
    
    switch (_gameObjectType)
    {
        case BOMB_TYPE:
            usedPool = self.mainGameLayer.bombUsedPool;
            freePool = self.mainGameLayer.bombFreePool;
            maxlimit = (MIN_NUM_BOMBS_PER_TRACK * (trackNum + 1));
            break;
        case COIN_TYPE:
            usedPool = self.mainGameLayer.coinUsedPool;
            freePool = self.mainGameLayer.coinFreePool;
            maxlimit = (MIN_NUM_COINS_PER_TRACK * (trackNum + 1));
            break;
        case SPACE_TYPE:
            return nil;
    }

    // Since we want to push all objects into more outer circle, we force it here.
    preferredLocation.x = preferredLocation.x + COMMON_GRID_WIDTH;

    // Check to see if we can insert this one without overlapping
    for (int i=0; i<POOL_OBJ_COUNT_ON_TRACK(usedPool, trackNum); i++)
    {
        NSMutableArray *currentObjectArray = POOL_OBJS_ON_TRACK(usedPool, trackNum);
        CGRect currentObjectBoundingBox = ((GameObjectBase *)currentObjectArray[i]).gameObjectSprite.boundingBox;
        if (CGRectIntersectsRect(currentObjectBoundingBox,
                                 CGRectMake(preferredLocation.x - (currentObjectBoundingBox.size.width/2),
                                            preferredLocation.y - (currentObjectBoundingBox.size.height/2) ,
                                            currentObjectBoundingBox.size.width,
                                            currentObjectBoundingBox.size.height)))
        {
            return nil;
        }
    }
    newObject = [freePool takeObjectFromTrack:trackNum];
    if (newObject != nil) {
        newObject.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
        newObject.angleRotated = 0;
        newObject.radius = preferredLocation.x - COMMON_SCREEN_CENTER.x;
        [newObject moveTo:preferredLocation];
        newObject.gameObjectSprite.visible = 1;
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
