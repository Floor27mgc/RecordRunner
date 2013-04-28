//
//  PowerShield.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/2/13.
//
//

#import "Power.h"

#define SHIELD_LIFETIME_SEC  5
#define BLINK_WHEN_REMAINING 3

@interface PowerShield : Power

- (void) toggleInvincibleRecord:(int) elapsedMilliseconds;

@property (nonatomic) NSDate * startTime;
@property (nonatomic) BOOL startedBlink;
@property (nonatomic) NSInteger * lastToggle;


@end
