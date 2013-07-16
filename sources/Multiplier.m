//
//  Multiplier.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 4/7/13.
//
//

#import "Multiplier.h"
#import "GameLayer.h"

@implementation Multiplier

@synthesize multiplierLabel;
@synthesize animationManager;
@synthesize multiplierValue;
@synthesize timerLifeInSec;
@synthesize multiplierTime;
@synthesize highestMultiplierValueEarned;
@synthesize timeAboveTen;
@synthesize speedDifference;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        self.animationManager = self.userObject;

        [self reset];
    }
        
    return self;
}

// -----------------------------------------------------------------------------------
- (void) prepare
{
    self.animationManager = self.userObject;
    multiplierLabel.color = ccWHITE;
    
    
    [self.animationManager runAnimationsForSequenceNamed:@"appear"];
    
    [self reset];
}


// -----------------------------------------------------------------------------------
- (void) incrementMultiplier:(int)amount
{
    multiplierValue += amount;
    
    // set highest multiplier seen
    if (multiplierValue > highestMultiplierValueEarned) {
        highestMultiplierValueEarned = multiplierValue;
    }
    
    // start timing if we have exceeded 10x
    if (multiplierValue >= 10) {
        timeAboveTen = [NSDate date];
    }
    
    [self.multiplierLabel setString:[NSString stringWithFormat:@"x %d",
                                    multiplierValue]];
    
    ccColor3B currentColor = multiplierLabel.color;
    [self.multiplierLabel setColor:currentColor];
    [self.animationManager runAnimationsForSequenceNamed:@"bounce_multiplier"];

    timerLifeInSec = MULTIPLIER_LIFE_TIME_SEC;
    
    // perform multiplier timing operations
    if (multiplierTime == [NSDate distantFuture]) {
        multiplierTime = [NSDate date];
    }
}

// -----------------------------------------------------------------------------------
- (void) decrementMultiplier:(int)amount
{
    if (amount >= multiplierValue) {
        multiplierValue = 1;
    } else {
        multiplierValue -= amount;
    }
    
    // reset the timer
    if (multiplierValue > 1) {
        [self.animationManager runAnimationsForSequenceNamed:@"bounce_multiplier"];
        timerLifeInSec = MULTIPLIER_LIFE_TIME_SEC;
        
        // perform multiplier timing operations
        if (multiplierTime == [NSDate distantFuture]) {
            multiplierTime = [NSDate date];
        }
    } else {
        timerLifeInSec = 0;
    }
    
    // stop timing if we're below 10x
    if (multiplierValue < 10) {
        timeAboveTen = [NSDate distantFuture];
    }
    
    ccColor3B currentColor = multiplierLabel.color;
    [self.multiplierLabel setColor:currentColor];
    
    [self.multiplierLabel setString:[NSString stringWithFormat:@"x %d",
                                     multiplierValue]];
}

// -----------------------------------------------------------------------------------
- (int) secondsAbove10x
{
    if (timeAboveTen == [NSDate distantFuture]) {
        return 0;
    }
    
    return [timeAboveTen timeIntervalSinceNow];
}

// -----------------------------------------------------------------------------------
- (int) getMultiplier
{
    return multiplierValue;
}

// -----------------------------------------------------------------------------------
- (void) reset
{
    multiplierValue = 1;
    highestMultiplierValueEarned = 1;
    timerLifeInSec = 0;
    speedDifference = 0;
    timeAboveTen = [NSDate distantFuture];
    multiplierTime = [NSDate distantFuture];
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    if (multiplierValue > 1) {
        int elapsed = [multiplierTime timeIntervalSinceNow];
    
        if (elapsed < 0) {
            timerLifeInSec += elapsed;
            multiplierTime = [NSDate date];
        
            if (timerLifeInSec == 0) {
                multiplierTime = [NSDate distantFuture];
            }
        
            //Decrement the multiplier if time runs out and player is NOT invincible
            if (timerLifeInSec % MULTIPLIER_LIFE_TIME_SEC == 0 && ![GameLayer sharedGameLayer].player.hasShield) {
                [self decrementMultiplier:1];
            }
        }
    }
}

@end
