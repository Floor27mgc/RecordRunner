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
#define kPlayerRadialSpeed 32
#define kPlayerHitBoxSegmentWidth kPlayerSpeed

typedef enum
{
    kMoveOutToIn  = -1,
    kMoveStill    =  0,
    kMoveInToOut  =  1
} direction_t;

#define PLAYER_START_POSITION COMMON_SCREEN_CENTER

#define PLAYER_LEFT_BOUND  (COMMON_SCREEN_MARGIN_LEFT+(COMMON_GRID_WIDTH/2))
#define PLAYER_RIGHT_BOUND (COMMON_SCREEN_MARGIN_RIGHT-(COMMON_GRID_WIDTH/2))
//#define PLAYER_RADIUS_OUTER_MOST (COMMON_GRID_WIDTH * (MAX_NUM_TRACK+1)-(COMMON_GRID_WIDTH/2))
@interface GameObjectPlayer : GameObjectBase
{
    direction_t direction;
    CCMotionStreak *playerStreak;
}
- (void) changeDirection;

- (void) setSheilded: (BOOL) trigger;

@property (nonatomic) direction_t direction;
@property (nonatomic) int playerRadialSpeed; // How fast the player zips between center and
                                             // outer most circle
@property (nonatomic) int radialTravelAngle; // Angle at which the player moves from edge to edge
@property (nonatomic) int playerFacingAngle; // What angle is the player facing
@property (nonatomic,strong) CCMotionStreak *playerStreak;
@property CGMutablePathRef playerBoundingPath;
@property CGMutablePathRef PlayerBoundingPathCrossing;
@property CGMutablePathRef PlayerBoundingPathStill;
@property (nonatomic, strong) CCNode *dummyPlayer;
@property (nonatomic) BOOL hasShield;

@end
