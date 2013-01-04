//
//  GameObjectPlayer.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import <Foundation/Foundation.h>
#import "common.h"
#import "GameObjectBase.h"
#define kPlayerSpeed 32
#define kPlayerHitBoxSegmentWidth kPlayerSpeed

typedef enum
{
    kMoveLeft  = -1,
    kMoveStill =  0,
    kMoveRight =  1
} direction_t;

#define PLAYER_START_POSITION ccp(COMMON_SCREEN_MARGIN_LEFT+(COMMON_GRID_WIDTH/2), 380)
#define PLAYER_LEFT_BOUND  (COMMON_SCREEN_MARGIN_LEFT+(COMMON_GRID_WIDTH/2))
#define PLAYER_RIGHT_BOUND (COMMON_SCREEN_MARGIN_RIGHT-(COMMON_GRID_WIDTH/2))

@interface GameObjectPlayer : GameObjectBase
{
    direction_t direction;
    CCMotionStreak *playerStreak;
}
- (void) changeDirection;

@property (nonatomic) direction_t direction;
@property (nonatomic,strong) CCMotionStreak *playerStreak;
@end
