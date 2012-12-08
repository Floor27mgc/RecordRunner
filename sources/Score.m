//
//  Score.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/8/12.
//
//

#import "Score.h"

@implementation Score

@synthesize score = _score;
@synthesize scoreValue = _scoreValue;

// -----------------------------------------------------------------------------------
- (void) increment:(int)amount
{
    _scoreValue += amount;
}

// -----------------------------------------------------------------------------------
- (void) decrement:(int)amount
{
    if (amount > _scoreValue) {
        _scoreValue = 0;
    } else {
        _scoreValue -= amount;
    }
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    _score = [CCLabelBMFont labelWithString:@"0" fntFile:@"fixed.fnt"];
    NSString * scoreString = [NSString stringWithFormat:@"%d", _scoreValue];
    [_score setString:scoreString];
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    _scoreValue = 0;
    [self showNextFrame];
}

@end
