//
//  PowerUp.h
//  Rotato
//
//  Created by Matt Cleveland on 8/25/13.
//
//

#import <Foundation/Foundation.h>

#define MULTIPLIER_BASE_COOLDOWN_TIME_SEC   4

#define TOP_GREEN    0
#define TOP_RED      1
#define TOP_BLUE     2
#define BOTTOM_GREEN 3
#define BOTTOM_RED   4
#define BOTTOM_BLUE  5

@interface PowerUp : NSObject

// these should be in order corresponding to the #defines above
// indicating the tile order on the power up screen
typedef enum {
    BLANK_SPACE, //Used for the menu at the top.
    RECORD_SPINS_SLOWER,
    INCREASE_STAR_SPAWN_RATE,
    CLOSE_CALL_TIMES_2,
    MINIMUM_MULTIPLIER_OF_3,
    START_WITH_SHIELD,
    INCREASE_MULTIPLIER_COOLDOWN_BY_3,
    numPowerUps

} PowerUpType;

- (id) initWithType:(PowerUpType) pType;
- (BOOL) Purchase;
- (BOOL) Available;
- (void) Reset;

@property (nonatomic, assign) int cost;
@property (nonatomic, assign) PowerUpType type;

@end
