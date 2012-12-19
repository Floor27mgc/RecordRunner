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
@synthesize prevScore = _prevScore;

// -----------------------------------------------------------------------------------
- (id) init
{
    _scoreValue = 0;
    _prevScore  = 0;
    
    if(self = [super init]) {
        _score = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFontTest.fnt"];
        NSString * scoreString = [self generateScoreString];
        [_score setString:scoreString];
        CGSize size = [[CCDirector sharedDirector] winSize];
        _score.position = ccp(kScorePositionX,kScorePositionY);
        
    }

    return (self);
}

// -----------------------------------------------------------------------------------
- (NSString *) generateScoreString
{
    NSString * scoreString = [NSString stringWithFormat:@"Score %d", _scoreValue];
    return scoreString;
}

// -----------------------------------------------------------------------------------
- (void) incrementScore:(int)amount
{
    _scoreValue += amount;
}

// -----------------------------------------------------------------------------------
- (void) decrementScore:(int)amount
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
    if (_prevScore != _scoreValue) {
        NSString * scoreString = [self generateScoreString];
        [_score setString:scoreString];
        _prevScore = _scoreValue;
    }
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    _scoreValue = 0;
    [self showNextFrame];
}

@end
