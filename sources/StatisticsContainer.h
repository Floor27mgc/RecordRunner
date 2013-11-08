//
//  StatisticsContainer.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 3/19/13.
//
//

#import <Foundation/Foundation.h>
#import "StatisticsTracker.h"

typedef enum {
    COIN_STATS,       // tick during execution
    BOMB_STATS,       // tick during execution
    SCORE_STATS,      // update at end         -- TODO when score is implemented
    SHIELD_STATS,     // tick during execution
    TIME_STATS,       // update at end
    TAPS_STATS,       // tick during execution
    ROTATIONS_STATS,  // tick during execution -- TBD HOW
    
    STATS_RECORD_SPINS_SLOWER,
    STATS_CLOSE_CALL_TIMES_2,
    STATS_START_WITH_SHIELD,
    STATS_INCREASE_STAR_SPAWN_RATE,
    STATS_MINIMUM_MULTIPLIER_OF_3,
    STATS_DOUBLE_COINS,
    
    POWERUP_RECORD_SPINS_SLOWER,
    POWERUP_INCREASE_STAR_SPAWN_RATE,
    POWERUP_CLOSE_CALL_TIMES_2,
    POWERUP_MINIMUM_MULTIPLIER_OF_3,
    POWERUP_START_WITH_SHIELD,
    POWERUP_DOUBLE_COINS,
    
    STATS_TYPE_MAX
} statistics_types_t;

@interface StatisticsContainer : NSObject

// return pointer to StatisticsTracker object
- (StatisticsTracker *) at: (int) index;

// reset the current game timer
- (void) resetGameTimer;

// update stats tracker for _this_ game's time
- (void) updateGameTimeStats;

// log stats with Flurry
- (void) writeStats;

// return string value of types in stats type struct
- (NSString *) statsTypeToString: (statistics_types_t) type;

// return the time of the current game
- (NSTimeInterval) getCurrentGameTimeElapsed;

@property (nonatomic, strong) NSMutableArray * container;
@property (nonatomic, strong) NSDate * gameStartTime;
@property (nonatomic, strong) NSDate * sessionStartTime;

@end
