//
//  Multiplier.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 4/7/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"

#define SPEED_THRESHOLD_1      4
#define SPEED_THRESHOLD_2      7
#define SPEED_THRESHOLD_3     10
#define SPEED_INCREASE_AMOUNT .1

@interface Multiplier : CCNode

@property (nonatomic) CCLabelTTF * multiplierLabel;
@property (nonatomic) CCBAnimationManager * animationManager;
@property (nonatomic) int multiplierValue;
@property (nonatomic) int timerLifeInSec;
@property (nonatomic) int highestMultiplierValueEarned;
@property (nonatomic) NSDate * timeAboveTen;
@property (nonatomic) NSDate * multiplierTime;
@property (nonatomic) int speedDifference;

- (int) secondsAbove10x;
- (void) incrementMultiplier:(int) amount;
- (void) decrementMultiplier:(int) amount;
- (void) showNextFrame;
- (void) prepare;
- (int) getMultiplier;
- (void) reset;
- (void) setShield;
- (void) resumeMultiCountdown;
- (void) die;
- (void) explode;


@end
