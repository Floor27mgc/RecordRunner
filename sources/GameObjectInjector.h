//
//  GameObjectInjector.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 12/11/12.
//
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
//@class GameLayer;
typedef enum {
    kPatternDiamond,
    kPatternRectangle,    
    kPatternTriangle,
    kPatternSquare,
    kPatternCircle,
    kPatternHeart
} pattern_type;

#define PATTERN_ALIGN_TO_GRID(_location) do { \
    _location.x = ((int) (_location.x / COMMON_GRID_WIDTH)  * COMMON_GRID_WIDTH)  + (COMMON_GRID_WIDTH/2);    \
    _location.y = ((int) (_location.y / COMMON_GRID_HEIGHT) * COMMON_GRID_HEIGHT) + (COMMON_GRID_HEIGHT/2); \
} while (0)


@interface GameObjectInjector : NSObject

//@property (nonatomic,assign) GameLayer *mainGameLayer;
//@property (nonatomic,assign) GameObjectBase *lastObject;
@property CGMutablePathRef injectorHitBoxPath;
@property (nonatomic, strong) CCNode *dummyInjectorBox;

- (GameObjectBase *) injectObjectToTrack: (int) trackNum
                                 atAngle: (int) insertionAngle
                          gameObjectType: (game_object_t)_gameObjectType
                              effectType: (effect_type_t) _effectType;
//- (bool) isLastObjectOnScreen;

@end
