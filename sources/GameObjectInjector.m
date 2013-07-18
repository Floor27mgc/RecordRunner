//
//  GameObjectInjector.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 12/11/12.
//
//

#import "GameObjectInjector.h"
#import "scoreMini.h"

@interface GameObjectInjector ()
{
    BOOL isInjectorPause;
}
@end


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
        isInjectorPause = TRUE;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
//Score objects are those small numbers that float after collecting something.
//They are a bit different than objects because they don't rotate on the track, so I created a second method for them.
- (GameObjectBase *) showScoreObject: (int) trackNum message:(NSString *) message
{
    Queue * usedPool;
    Queue * freePool;
    GameObjectBase * newObject = nil;
    int maxlimit;
    
    
    CGPoint preferredLocation = ccp ((COMMON_RECORD_CENTER_X +
                                      RADIUS_FROM_TRACKNUM(trackNum)*cos(CC_DEGREES_TO_RADIANS(0))),
                                     (COMMON_RECORD_CENTER_Y +
                                      RADIUS_FROM_TRACKNUM(trackNum)*sin(CC_DEGREES_TO_RADIANS(0))));
    
    
    usedPool = [GameLayer sharedGameLayer].scoreUsedPool;
    freePool = [GameLayer sharedGameLayer].scoreFreePool;
    maxlimit = (MIN_NUM_COINS_PER_TRACK * (trackNum + 1));
    
    
    newObject = [freePool takeObjectFromTrack:trackNum];
    
    //Verify we get something back. If we get back nil then we know there is nothing left in the pool.
    
    if (newObject != nil) {
        
        //Cast the object to a score object.
        NSAssert([newObject isKindOfClass: [scoreMini class]], @"Return value is not of type scoreMini");
        scoreMini * newScoreObject = (scoreMini *) newObject;
        
        
        newScoreObject.anchorPoint = ccp(0.5,0.5);
        newScoreObject.radius = RADIUS_FROM_TRACKNUM(trackNum);
        [newScoreObject moveTo:preferredLocation];
        newScoreObject.visible = 1;
        [newScoreObject setScoreText: message];
        
        [newScoreObject.animationManager runAnimationsForSequenceNamed:@"show_score"];
        
        //Add the score to the used pools
        [usedPool addObject:newScoreObject toTrack:trackNum];
        
        return newScoreObject;
    }
    else{
        //No Objects remain in the pool. Clear it out.
        NSLog(@"out of objects");
        return nil;
    }
        
  
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
    
    // Check if injector is in pause mode.
    if (isInjectorPause)
    {
        return nil;
    }
    
    CGPoint preferredLocation = ccp ((COMMON_RECORD_CENTER_X +
                                      RADIUS_FROM_TRACKNUM(trackNum)*cos(CC_DEGREES_TO_RADIANS(insertionAngle))),
                                     (COMMON_RECORD_CENTER_Y +
                                      RADIUS_FROM_TRACKNUM(trackNum)*sin(CC_DEGREES_TO_RADIANS(insertionAngle))));
    
    // If we happen to insert to where player is currently at,
    // we bail.
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
        case SCORE_TYPE:
        //Note SCORE_TYPE is not here because it is injected using the showScoreObject
        return nil;
    }

    if (_gameObjectType == BOMB_TYPE)
    {
        if ([self isAnybodyNearMeWithInAngleRange:ANGULAR_SPACING_BETWEEN_BOMBS_DEG
                                          myAngle:insertionAngle
                                       inUsedPool:usedPool
                                          OnTrack:trackNum])
        {
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
            
            //There is a different icon if the player is invincible vs normal spawn.
            if ([[GameLayer sharedGameLayer].player hasShield])
            {
                
                [newObject.animationManager runAnimationsForSequenceNamed:@"Invincible"];
            }
            else
            {
                [newObject.animationManager runAnimationsForSequenceNamed:@"Spawn"];
                
            }
            
            if (![[GameLayer sharedGameLayer].player hasShield])
            {
                [[SoundController sharedSoundController] playSoundIdx:SOUND_BOMB_POPUP fromObject:newObject];
            }
        }
        if ([newObject isKindOfClass:[Coin class]]) {
            [newObject.animationManager runAnimationsForSequenceNamed:@"Spawn"];
            
            int soundIdxToPlay;
            switch (trackNum)
            {
                case 0: soundIdxToPlay = SOUND_FILENAME_TRK_0_COIN_POPUP;
                    break;
                case 1: soundIdxToPlay = SOUND_FILENAME_TRK_1_COIN_POPUP;
                    break;
                case 2: soundIdxToPlay = SOUND_FILENAME_TRK_2_COIN_POPUP;
                    break;
                case 3: soundIdxToPlay = SOUND_FILENAME_TRK_3_COIN_POPUP;
                    break;
                case 4: soundIdxToPlay = SOUND_FILENAME_TRK_4_COIN_POPUP;
                    break;
                case 5: soundIdxToPlay = SOUND_FILENAME_TRK_4_COIN_POPUP;
                    break;
                default:
                    soundIdxToPlay = SOUND_FILENAME_TRK_0_COIN_POPUP;
                    break;
            }

            
            [[SoundController sharedSoundController] playSoundIdx:soundIdxToPlay fromObject:newObject];
        }

        [usedPool addObject:newObject toTrack:trackNum];
    } else {
        //No Objects remain in the pool. Don't post anything to the record.
        NSLog(@"out of objects");
    }
 
    return newObject;
}

// -----------------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------------
- (void) startInjector
{
    isInjectorPause = FALSE;
}

// -----------------------------------------------------------------------------------
- (void) stopInjector
{
    isInjectorPause = TRUE;
}

@end
