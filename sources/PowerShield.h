//
//  PowerShield.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/2/13.
//
//

#import "Power.h"

#define SHIELD_LIFETIME_SEC 5

@interface PowerShield : Power

@property (nonatomic) NSDate * startTime;

@end
