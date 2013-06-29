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

@synthesize injectorHitBoxPath;
@synthesize dummyInjectorBox;

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
        dummyInjectorBox.position = COMMON_RECORD_CENTER;
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
    
    CGPoint preferredLocation = ccp ((COMMON_RECORD_CENTER_X +
                                      RADIUS_FROM_TRACKNUM(trackNum)*cos(CC_DEGREES_TO_RADIANS(insertionAngle))),
                                     (COMMON_RECORD_CENTER_Y +
                                      RADIUS_FROM_TRACKNUM(trackNum)*sin(CC_DEGREES_TO_RADIANS(insertionAngle))));
    
    // If we happen to insert to where player is currently at,
    // we bails.
    dummyInjectorBox.rotation = insertionAngle;

    switch (_gameObjectType)
    {
        case BOMB_TYPE:
            usedPool = [GameLayer sharedGameLayer].bombUsedPool;
            freePool = [GameLayer sharedGameLayer].bombFreePool;
            maxlimit = (MIN_NUM_BOMBS_PER_TRACK * (trackNum + 1));
            break;
        case COIN_TYPE:
            usedPool = [GameLayer sharedGameLayer].coinUsedPool;
            freePool = [GameLayer sharedGameLayer].coinFreePool;
            maxlimit = (MIN_NUM_COINS_PER_TRACK * (trackNum + 1));
            break;
        case POWER_ICON_TYPE:
            usedPool = [GameLayer sharedGameLayer].powerIconUsedPool;
            freePool = [GameLayer sharedGameLayer].powerIconFreePool;
            maxlimit = (MIN_NUM_POWER_ICONS_PER_TRACK * (trackNum + 1));
            break;
        case SPACE_TYPE:
        case POWER_TYPE:
            return nil;
    }

    if (_gameObjectType == BOMB_TYPE)
    {
        if ([self isAnybodyNearMeWithInAngleRange:ANGULAR_SPACING_BETWEEN_BOMBS_DEG
                                          myAngle:insertionAngle
                                       inUsedPool:usedPool
                                          OnTrack:trackNum])
        {
//            NSLog(@"Sombody nears me");
            return nil;
        }
    }
        
    // Check to see if we can insert this one without overlapping
    for (int i=0; i<POOL_OBJ_COUNT_ON_TRACK([GameLayer sharedGameLayer].coinUsedPool, trackNum); i++)
    {
        NSMutableArray *currentObjectArray = POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].coinUsedPool, trackNum);
        CGPoint currentObjectPosition = ((GameObjectBase *)currentObjectArray[i]).position;
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


    for (int i=0; i<POOL_OBJ_COUNT_ON_TRACK([GameLayer sharedGameLayer].bombUsedPool, trackNum); i++)
    {
        NSMutableArray *currentObjectArray = POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].bombUsedPool, trackNum);
        CGPoint currentObjectPosition = ((GameObjectBase *)currentObjectArray[i]).position;
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

    for (int i=0;
         i<POOL_OBJ_COUNT_ON_TRACK([GameLayer sharedGameLayer].powerIconUsedPool, trackNum);
         i++)
    {
        NSMutableArray *currentObjectArray =POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].powerIconUsedPool, trackNum);
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

    newObject = [freePool takeObjectFromTrack:trackNum];
    if (newObject != nil) {
        newObject.anchorPoint = ccp(0.5,0.5);
        newObject.angleRotated = insertionAngle;
        newObject.radius = RADIUS_FROM_TRACKNUM(trackNum);
        [newObject moveTo:preferredLocation];
        newObject.visible = 1;
        if ([newObject isKindOfClass:[Bomb class]]) {
            [newObject.animationManager runAnimationsForSequenceNamed:@"Spawn"];
            [[SoundController sharedSoundController] playSoundIdx:SOUND_FILENAME_IDX_BOMB_POPUP fromObject:newObject];
        }
        if ([newObject isKindOfClass:[Coin class]]) {
            [newObject.animationManager runAnimationsForSequenceNamed:@"Spawn"];
            [[SoundController sharedSoundController] playSoundIdx:SOUND_FILENAME_IDX_COIN_POPUP fromObject:newObject];
        }

        [usedPool addObject:newObject toTrack:trackNum];
    } else {
        NSLog(@"out of object");
    }
 
    return newObject;
}

- (Boolean) isAnybodyNearMeWithInAngleRange: (float) angleRange
                                    myAngle: (float) _myAngle
                                 inUsedPool: (Queue *)_usedPool
                                    OnTrack: (int) trackNum
{
    int myAngleNormalized = (NORMALIZE_ANGLE(_myAngle));
    int angleRangeNormalized = (NORMALIZE_ANGLE(angleRange));
    GameObjectBase *gameObject;
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_usedPool, trackNum); ++i) {
            gameObject = POOL_OBJS_ON_TRACK(_usedPool, trackNum)[i];

            if (((myAngleNormalized + angleRangeNormalized) >
                 NORMALIZE_ANGLE(gameObject.angleRotated)) &&
                ((myAngleNormalized - angleRangeNormalized) <
                 NORMALIZE_ANGLE(gameObject.angleRotated)))
            {
                return true;
            }
        }
    }
    
    return false;
    
}
@end
