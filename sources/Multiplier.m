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

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        self.animationManager = self.userObject;
        self.multiplierValue = 1;
        self.timerLifeInSec = 0;
        self.multiplierTime = [NSDate distantFuture];
    }
        
    return self;
}

- (void) prepare
{
    self.animationManager = self.userObject;
    self.multiplierValue = 1;
    self.timerLifeInSec = 0;
    self.multiplierTime = [NSDate distantFuture];
    multiplierLabel.color = ccMAGENTA;
}

// -----------------------------------------------------------------------------------
- (void) incrementMultiplier:(int)amount
{
    multiplierValue += amount;
    
    timerLifeInSec += MULTIPLIER_LIFE_TIME_SEC;
    
    if (multiplierTime == [NSDate distantFuture]) {
        multiplierTime = [NSDate date];
    }
    
    [self.multiplierLabel setString:[NSString stringWithFormat:@"x %d",
                                    multiplierValue]];
    
    ccColor3B currentColor = multiplierLabel.color;
//    currentColor.r += 50;
    [self.multiplierLabel setColor:currentColor];
    NSLog(@"mam %p", self.animationManager);
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
    
    ccColor3B currentColor = multiplierLabel.color;
//    currentColor.r -= 50;
    [self.multiplierLabel setColor:currentColor];
    
    [self.multiplierLabel setString:[NSString stringWithFormat:@"x %d",
                                     multiplierValue]];
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
        
            if (timerLifeInSec % MULTIPLIER_LIFE_TIME_SEC == 0) {
                [self decrementMultiplier:1];
            }
        }
    }
}
@end
