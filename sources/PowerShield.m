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
    [self.parentGameLayer.player setSheilded:YES];
    
    [super addPower];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    NSLog(@"Shield is running");
    if (elapsed > SHIELD_LIFETIME_SEC) {
        [self.parentGameLayer.player setSheilded:NO];
        [super resetPower];
    }
}

@end
