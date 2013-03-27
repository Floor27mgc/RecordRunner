//
//  PowerShield.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/2/13.
//
//

#import "Power.h"

#define SHIELD_LIFETIME_SEC    5
#define BLINK_WHEN_ELAPSED_SEC 3

@interface PowerShield : Power

@property (nonatomic) NSDate * startTime;
@property (nonatomic) BOOL triggeredBlink;

@end
