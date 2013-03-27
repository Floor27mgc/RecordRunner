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
@synthesize triggeredBlink = _triggeredBlink;

// -----------------------------------------------------------------------------------
- (void) addPower
{
    _startTime = [NSDate date];
    [[GameLayer sharedGameLayer].player setSheilded:YES];
    _triggeredBlink = NO;
    
    [super addPower];
    
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:SHIELD_STATS] tick];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    
    if (!_triggeredBlink && elapsed > BLINK_WHEN_ELAPSED_SEC) {
        _triggeredBlink = YES;
        [[GameLayer sharedGameLayer].player blinkShield];
    }
    
    if (elapsed > SHIELD_LIFETIME_SEC) {
        NSLog(@"Shield has expired");
        [[GameLayer sharedGameLayer].player setSheilded:NO];
        _triggeredBlink = NO;
        [super resetPower];
    }
}

@end
