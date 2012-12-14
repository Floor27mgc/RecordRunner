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

#define INJECTOR_GRID_WIDTH  32
#define INJECTOR_GRID_HEIGHT 32
#define INJECTOR_LEFT_BOUND PLAYER_LEFT_BOUND
#define INJECTOR_RIGHT_BOUND PLAYER_RIGHT_BOUND

#define PATTERN_ALIGN_TO_GRID(_location) do { \
    _location.x = ((int) (_location.x / INJECTOR_GRID_WIDTH) * INJECTOR_GRID_WIDTH); \
    _location.y = ((int) (_location.y / INJECTOR_GRID_HEIGHT) * INJECTOR_GRID_HEIGHT); \
} while (0)


@interface GameObjectInjector : NSObject

@property (nonatomic,assign) GameLayer *mainGameLayer;
@property (nonatomic,assign) GameObjectBase *lastObject;
+ (id) initWithGameLayer:(GameLayer *) gamelayer;
- (GameObjectBase *) injectObjectAt: (CGPoint)preferredLocation
         gameObjectType: (game_object_t)_gameObjectType
             effectType: (effect_type_t) _effectType;
- (void) injectObjectWithPattern:(pattern_type)_pattern_type
                initialXPosition: (CGPoint) _initialXPosition;
- (bool) isLastObjectOnScreen;

@end
