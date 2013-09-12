//
//  StatisticsContainer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 3/19/13.
//
//

#import "StatisticsContainer.h"
#import "Flurry.h"

@implementation StatisticsContainer

@synthesize container = _container;
@synthesize sessionStartTime = _sessionStartTime;
@synthesize gameStartTime = _gameStartTime;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self=[super init]) {
        _sessionStartTime = [NSDate date];
        
        _container = [[NSMutableArray alloc] init];
        for (int i = 0; i < STATS_TYPE_MAX; ++i) {
            StatisticsTracker * tracker = [[StatisticsTracker alloc] init];
            [tracker reset];
            tracker.typeLabel = [self statsTypeToString:i];
            [_container addObject:tracker];
        }
        
        [self resetGameTimer];
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (StatisticsTracker *) at:(int)index
{
    if (index < 0 || index > [_container count]) {
        return NULL;
    }
    
    return [_container objectAtIndex:index];
}

// -----------------------------------------------------------------------------------
- (NSTimeInterval) getCurrentGameTimeElapsed
{
    return (abs([_gameStartTime timeIntervalSinceNow]));
}

// -----------------------------------------------------------------------------------
- (void) resetGameTimer
{
    _gameStartTime = [NSDate date];
}

// -----------------------------------------------------------------------------------
- (void) updateGameTimeStats
{
    NSTimeInterval elapsed = abs([_gameStartTime timeIntervalSinceNow]);
    
    StatisticsTracker * gameTimeStats = [_container objectAtIndex:TIME_STATS];
    gameTimeStats.total = elapsed;
    NSLog(@"time total %d", gameTimeStats.total);
    //[gameTimeStats refresh];
}

// -----------------------------------------------------------------------------------
- (void) writeStats
{
    NSTimeInterval totalTimeElapsed = abs([_sessionStartTime timeIntervalSinceNow]);
    [self updateGameTimeStats];
    
    // log statistics for all the tracked objects
    for (int i = 0; i < STATS_TYPE_MAX; ++i) {
        [[self at:i] refresh];
        
        NSDictionary * params = [[self at:i] getFlurryDictionary];
        [Flurry logEvent:[[self at:i] getLabelString] withParameters:params];
    }
    
    // log total game time stats
    NSDictionary * timeParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [[NSNumber numberWithDouble:totalTimeElapsed] stringValue],
         @"TotalTimeElapsed",
         nil];
    
    [Flurry logEvent:@"Game_Over_Total_Time" withParameters:timeParams];
}

// -----------------------------------------------------------------------------------
- (NSString *) statsTypeToString:(statistics_types_t)type
{
    switch (type) {
        case COIN_STATS:
            return @"coin";
            break;
        case BOMB_STATS:
            return @"bombs_absorbed";
            break;
        case SCORE_STATS:
            return @"@score";
            break;
        case SHIELD_STATS:
            return @"shield";
            break;
        case TIME_STATS:
            return @"time";
            break;
        case TAPS_STATS:
            return @"taps";
            break;
        case ROTATIONS_STATS:
            return @"rotations";
            break;
        case STATS_RECORD_SPINS_SLOWER:
            return @"slow_record";
            break;
        case STATS_CLOSE_CALL_TIMES_2:
            return @"close_call_double";
            break;
        case STATS_START_WITH_SHIELD:
            return @"start_with_shield";
            break;
        case STATS_INCREASE_STAR_SPAWN_RATE:
            return @"increase_star_rate";
            break;
        case STATS_MINIMUM_MULTIPLIER_OF_3:
            return @"mult_min_3";
            break;
        case STATS_DOUBLE_COINS:
            return @"double_coin_value";
            break;
        case STATS_TYPE_MAX:
        default:
            return @"";
            break;
    }
}

@end
