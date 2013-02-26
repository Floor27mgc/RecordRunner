//
//  PowerShield.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/2/13.
//
//

#import "PowerShield.h"

@implementation PowerShield

@synthesize startTime = _startTime;

// -----------------------------------------------------------------------------------
- (void) addPower
{
    _startTime = [NSDate date];
    [[GameLayer sharedGameLayer].player setSheilded:YES];
    
    [super addPower];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    NSLog(@"Shield is running");
    if (elapsed > SHIELD_LIFETIME_SEC) {
        [[GameLayer sharedGameLayer].player setSheilded:NO];
        [super resetPower];
    }
}

@end
