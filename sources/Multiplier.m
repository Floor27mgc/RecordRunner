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
    
    
    [self reset];
}

// -----------------------------------------------------------------------------------
//This is called after the shield time is up so that we can continue counting down.
- (void) resumeMultiCountdown
{
    //Reset time back to 0
    timerLifeInSec = MULTIPLIER_LIFE_TIME_SEC;
    
    [self.animationManager runAnimationsForSequenceNamed:@"bounce_multiplier"];
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
- (void) pause
{
    [self.actionManager pauseAllRunningActions];
}

// -----------------------------------------------------------------------------------
- (void) resume
{
    timerLifeInSec = MULTIPLIER_LIFE_TIME_SEC;
    [self.actionManager resumeTarget:self];
}

// -----------------------------------------------------------------------------------
- (void) decrementMultiplier:(int)amount
{
    if (amount >= multiplierValue) {
        multiplierValue = 1;
    } else if (amount == -1)
    {   //This is sent if we want to do the full multiplier reset when time runs out.
        multiplierValue = 1;
    }
    else {
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
//Called when the player dies it just clears out the animation 
- (void) die
{
    
    [self.animationManager runAnimationsForSequenceNamed:@"disappear"];
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
    
    [self.multiplierLabel setString:[NSString stringWithFormat:@"x %d",
                                     multiplierValue]];
    
    [self.animationManager runAnimationsForSequenceNamed:@"appear"];
    
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
            if (timerLifeInSec % MULTIPLIER_LIFE_TIME_SEC == 0 &&
                ![GameLayer sharedGameLayer].player.hasShield ) {
                [self decrementMultiplier:-1];
            }
        }
    }
}


// -----------------------------------------------------------------------------------
//If the player has a shield, turn on the shield icon in the middle.
//Called by game layer
- (void) setShield
{
    [self.animationManager runAnimationsForSequenceNamed:@"invincible_active"];
}

@end
