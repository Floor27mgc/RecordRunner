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
- (id) init
{
    _scoreValue = 0;
    
    if(self = [super init]) {
        _score = [CCLabelBMFont labelWithString:@"0" fntFile:@"gorbNormal16.fnt"];
        NSString * scoreString = [NSString stringWithFormat:@"Score %d", _scoreValue];
        [_score setString:scoreString];
    }

    return (self);
}
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
    NSString * scoreString = [NSString stringWithFormat:@"Score %d", _scoreValue];
    [_score setString:scoreString];
    NSLog(@"Score is %d", _scoreValue);
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    _scoreValue = 0;
    [self showNextFrame];
}

@end
