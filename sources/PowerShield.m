//
//  PowerShield.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/2/13.
//
//

#import "PowerShield.h"
#import "GameInfoGlobal.h"

@implementation PowerShield

@synthesize startTime = _startTime;
@synthesize startedBlink = _startedBlink;

// -----------------------------------------------------------------------------------
- (void) addPower
{
    _startTime = [NSDate date];
    [[GameLayer sharedGameLayer].player setSheilded:YES];
    _startedBlink = NO;
    
    [super addPower];
    
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:SHIELD_STATS] tick];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    if (!_startedBlink && elapsed > SHIELD_LIFETIME_SEC - BLINK_WHEN_REMAINING) {
        _startedBlink = YES;
        [[GameLayer sharedGameLayer].player blink];
    }
    
    if (elapsed > SHIELD_LIFETIME_SEC) {
        NSLog(@"Shield has expired");
        [[GameLayer sharedGameLayer].player setSheilded:NO];
        _startedBlink = NO;
        [super resetPower];
    }
}

@end
