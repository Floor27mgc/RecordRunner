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

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        self.animationManager = self.userObject;
        self.multiplierValue = 1;
        self.highestMultiplierValueEarned = 1;
        self.timerLifeInSec = 0;
        self.timeAboveTen = [NSDate distantFuture];
        self.multiplierTime = [NSDate distantFuture];
    }
        
    return self;
}

// -----------------------------------------------------------------------------------
- (void) prepare
{
    self.animationManager = self.userObject;
    self.multiplierValue = 1;
    self.timerLifeInSec = 0;
    self.multiplierTime = [NSDate distantFuture];
    multiplierLabel.color = ccWHITE;//ccMAGENTA;
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
    
    // perform multiplier timing operations
    timerLifeInSec += MULTIPLIER_LIFE_TIME_SEC;
    
    if (multiplierTime == [NSDate distantFuture]) {
        multiplierTime = [NSDate date];
    }
    
    // increase speed if multiplier is above thresholds
    if (multiplierValue == SPEED_THRESHOLD_1 ||
        multiplierValue == SPEED_THRESHOLD_2 ||
        multiplierValue == SPEED_THRESHOLD_3) {
        
        [[GameLayer sharedGameLayer] changeGameAngularVelocityByDegree:
            SPEED_INCREASE_AMOUNT];
    }
    
    [self.multiplierLabel setString:[NSString stringWithFormat:@"x %d",
                                    multiplierValue]];
    
    ccColor3B currentColor = multiplierLabel.color;
    //    currentColor.r += 50;
    [self.multiplierLabel setColor:currentColor];
    [self.animationManager runAnimationsForSequenceNamed:@"bounce_multiplier"];
}

// -----------------------------------------------------------------------------------
- (void) decrementMultiplier:(int)amount
{
    if (amount >= multiplierValue) {
        multiplierValue = 1;
    } else {
        multiplierValue -= amount;
    }
    
    // stop timing if we're below 10x
    if (multiplierValue < 10) {
        timeAboveTen = [NSDate distantFuture];
    }
    
    // decrease speed if multiplier is drops below thresholds
    if (multiplierValue == SPEED_THRESHOLD_1 - 1 ||
        multiplierValue == SPEED_THRESHOLD_2 - 1 ||
        multiplierValue == SPEED_THRESHOLD_3 - 1) {

        [[GameLayer sharedGameLayer] changeGameAngularVelocityByDegree:
            (-SPEED_INCREASE_AMOUNT)];
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
