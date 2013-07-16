//
//  GameObjectInjector.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 12/11/12.
//
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"

#define PATTERN_ALIGN_TO_GRID(_location) do { \
    _location.x = ((int) (_location.x / COMMON_GRID_WIDTH)  * COMMON_GRID_WIDTH)  + (COMMON_GRID_WIDTH/2);    \
    _location.y = ((int) (_location.y / COMMON_GRID_HEIGHT) * COMMON_GRID_HEIGHT) + (COMMON_GRID_HEIGHT/2); \
} while (0)

#define NORMALIZE_ANGLE(_angle) (((int)_angle)%360)
#define ANGULAR_SPACING_BETWEEN_BOMBS_DEG 35
@interface GameObjectInjector : NSObject

@property CGMutablePathRef injectorHitBoxPath;
@property (nonatomic, strong) CCNode *dummyInjectorBox;

- (GameObjectBase *) showScoreObject: (int)trackNum
                             message: (NSString *) message;

- (GameObjectBase *) injectObjectToTrack: (int) trackNum
                                 atAngle: (int) insertionAngle
                          gameObjectType: (game_object_t)_gameObjectType
                              effectType: (effect_type_t) _effectType;

- (Boolean) isAnybodyNearMeWithInAngleRange: (float) angleRange
                                    myAngle: (float) _myAngle
                                 inUsedPool: (Queue *)_usedPool
                                    OnTrack: (int) trackNum;
- (void) startInjector;
- (void) stopInjector;

@end
