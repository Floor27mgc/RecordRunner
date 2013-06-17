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
@synthesize lastToggle = _lastToggle;

// -----------------------------------------------------------------------------------
- (void) addPower
{
    _startTime = [NSDate date];
    [[GameLayer sharedGameLayer].player setSheilded:YES];
    _startedBlink = NO;
    _lastToggle = 0;
    [GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield = 0;
    [super addPower];
    
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:SHIELD_STATS] tick];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    
    // convert time elapsed to milliseconds
    double elapsedMilliseconds = [_startTime timeIntervalSinceNow] * -1000.0;
    /*if (!_startedBlink && elapsed > SHIELD_LIFETIME_SEC - BLINK_WHEN_REMAINING) {
        NSLog(@"blinking player");
        _startedBlink = YES;
        [GameLayer sharedGameLayer].invincibleRecord.visible = YES;
    }*/

    // toggle first invincible record
    if (!_startedBlink) {
        [GameLayer sharedGameLayer].invincibleRecord.visible = YES;
        _startedBlink = YES;
    } else {
        [self toggleInvincibleRecord:(int)elapsedMilliseconds];
    }
    
    if (elapsed > SHIELD_LIFETIME_SEC) {
        NSLog(@"Shield has expired");
        [[GameLayer sharedGameLayer].player setSheilded:NO];
        [GameLayer sharedGameLayer].invincibleRecord.visible = NO;
        _startedBlink = NO;
        _lastToggle = 0;
        [super resetPower];
    }
}

// -----------------------------------------------------------------------------------
- (void) toggleInvincibleRecord:(int)elapsedMilliseconds
{
    bool toggle = [GameLayer sharedGameLayer].invincibleRecord.visible;
    
    if (elapsedMilliseconds > 5000 &&
        (int)_lastToggle < 5000) {
        toggle = NO;
        _lastToggle = 5000;
    } else if (elapsedMilliseconds > 4875 &&
               (int)_lastToggle < 4875) {
        toggle = YES;
        _lastToggle = 4875;
    } else if (elapsedMilliseconds > 4750 &&
               (int)_lastToggle < 4750) {
        toggle = NO;
        _lastToggle = 4750;
    } else if (elapsedMilliseconds > 4625 &&
               (int)_lastToggle < 4625) {
        toggle = YES;
                _lastToggle = 4625;
    } else if (elapsedMilliseconds > 4500 &&
               (int)_lastToggle < 4500) {
        toggle = NO;
        _lastToggle = 4500;
    } else if (elapsedMilliseconds > 4375 &&
               (int)_lastToggle < 4375) {
        toggle = YES;
        _lastToggle = 4375;
    } else if (elapsedMilliseconds > 4250 &&
               (int)_lastToggle < 4250) {
        toggle = NO;
        _lastToggle = 4250;
    } else if (elapsedMilliseconds > 4125 &&
               (int)_lastToggle < 4125) {
        toggle = YES;
        _lastToggle = 4125;
    } else if (elapsedMilliseconds > 4000 &&
               (int)_lastToggle < 4000) {
        toggle = NO;
        _lastToggle = 4000;
    } /*else if (elapsedMilliseconds > 3750 &&
               (int)_lastToggle < 3750) {
        toggle = YES;
        _lastToggle = 3750;
    } else if (elapsedMilliseconds > 3500 &&
               (int)_lastToggle < 3500) {
        toggle = NO;
        _lastToggle = 3500;
    } else if (elapsedMilliseconds > 3000 &&
               (int)_lastToggle < 3000) {
        toggle = YES;
        _lastToggle = 3000;
    } else if (elapsedMilliseconds > 2500 &&
               (int)_lastToggle < 2500) {
        toggle = NO;
        _lastToggle = 2500;
    } else if (elapsedMilliseconds > 2000 &&
               (int)_lastToggle < 2000) {
        toggle = YES;
        _lastToggle = 2000;
    } else if (elapsedMilliseconds > 1000 &&
               (int)_lastToggle < 1000) {
        toggle = NO;
        _lastToggle = 1000;
    }*/
    
    [GameLayer sharedGameLayer].invincibleRecord.visible = toggle;
}

@end
