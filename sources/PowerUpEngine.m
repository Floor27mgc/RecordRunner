//
//  PowerUpEngine.m
//  Rotato
//
//  Created by Matt Cleveland on 8/25/13.
//
//

#import "PowerUpEngine.h"

@implementation PowerUpEngine

@synthesize PowerUps;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {

        PowerUps = [[NSMutableArray alloc] initWithCapacity:numPowerUps];
        // blank_space is just for nothing so we can have a clear menu
        PowerUp * power0 = [[PowerUp alloc] initWithType:BLANK_SPACE];
        [PowerUps addObject:power0];
        
        // initialize each of the power up objects per its type
        PowerUp * power1 = [[PowerUp alloc] initWithType:RECORD_SPINS_SLOWER];
        [PowerUps addObject:power1];
        
        PowerUp * power2 = [[PowerUp alloc] initWithType:CLOSE_CALL_TIMES_2];
        [PowerUps addObject:power2];
        
        PowerUp * power3 = [[PowerUp alloc] initWithType:START_WITH_SHIELD];
        [PowerUps addObject:power3];
        
        PowerUp * power4 = [[PowerUp alloc] initWithType:INCREASE_STAR_SPAWN_RATE];
        [PowerUps addObject:power4];
        
        PowerUp * power5 = [[PowerUp alloc] initWithType:MINIMUM_MULTIPLIER_OF_3];
        [PowerUps addObject:power5];
        
        PowerUp * power6 =
            [[PowerUp alloc] initWithType:DOUBLE_COINS];
        [PowerUps addObject:power6];
    }
    
    return self;
}

// -----------------------------------------------------------------------------------
// accessor to Available method of PowerUp class
- (BOOL) IsAvaiable:(PowerUpType)type
{
    if (type >= numPowerUps) {
        return NO;
    }
    
    return [[PowerUps objectAtIndex:type] Available];
}

// -----------------------------------------------------------------------------------
// accessor to Purchase method of PowerUp class
- (BOOL) Purchase:(PowerUpType)type
{
    if (type >= numPowerUps) {
        return NO;
    }
    
    return [[PowerUps objectAtIndex:type] Purchase];
}

// -----------------------------------------------------------------------------------
// reset all the power ups
- (void) ResetPowerUps
{
    for (PowerUp * p in PowerUps) {
        [p Reset];
    }
}

@end
