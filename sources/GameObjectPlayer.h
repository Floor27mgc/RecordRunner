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
#import "CCBAnimationManager.h"
//#import "GameLayer.h"
#define kPlayerRadialSpeed 32
#define kPlayerHitBoxSegmentWidth kPlayerSpeed

typedef enum
{
    kMoveOutToIn  = -1,
    kMoveStill    =  0,
    kMoveInToOut  =  1
} direction_t;

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
@property (nonatomic) int playerFacingAngle; // What angle is the player facing

@property (nonatomic) BOOL hasShield;

@end
