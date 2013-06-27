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

#define MULTIPLIER_LIFE_TIME_SEC   5
#define SPEED_THRESHOLD_1      4
#define SPEED_THRESHOLD_2      7
#define SPEED_THRESHOLD_3     10
#define SPEED_INCREASE_AMOUNT .4

@interface Multiplier : CCNode

@property (nonatomic) CCLabelTTF * multiplierLabel;
@property (nonatomic) CCBAnimationManager * animationManager;
@property (nonatomic) int multiplierValue;
@property (nonatomic) int timerLifeInSec;
@property (nonatomic) int highestMultiplierValueEarned;
@property (nonatomic) NSDate * timeAboveTen;
@property (nonatomic) NSDate * multiplierTime;

- (int) secondsAbove10x;
- (void) incrementMultiplier:(int) amount;
- (void) decrementMultiplier:(int) amount;
- (void) showNextFrame;
- (void) prepare;
- (int) getMultiplier;

@end
