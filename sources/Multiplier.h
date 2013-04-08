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

@interface Multiplier : CCNode

@property (nonatomic) CCLabelTTF * multiplierLabel;
@property (nonatomic) CCBAnimationManager * animationManager;
@property (nonatomic) int multiplierValue;
@property (nonatomic) int timerLifeInSec;
@property (nonatomic) NSDate * multiplierTime;

- (void) incrementMultiplier:(int) amount;
- (void) decrementMultiplier:(int) amount;
- (void) showNextFrame;
-(void) prepare;

@end
