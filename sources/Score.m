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
@synthesize label = _label;

// -----------------------------------------------------------------------------------
- (id) init
{
    _scoreValue = 0;
    _prevScore  = 0;
    
    if(self = [super init]) {

    }

    return (self);
}

// -----------------------------------------------------------------------------------
- (void) prepareScore:(NSString *) myLabel
{
    _label = myLabel;
    _score = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFontTest.fnt"];
    NSString * scoreString = [self generateScoreString];
    [_score setString:scoreString];
    CGSize size = [[CCDirector sharedDirector] winSize];
    _score.position = ccp(kScorePositionX,kScorePositionY);
}

// -----------------------------------------------------------------------------------
- (NSString *) generateScoreString
{
    NSString * scoreString = [NSString stringWithFormat:@"%@ %d",
                              _label, _scoreValue];
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
- (void) moveBy:(CGPoint)relativePoint
{
    int newX = _score.position.x + relativePoint.x;
    int newY = _score.position.y + relativePoint.y;
    _score.position = ccp(newX, newY);
}

// -----------------------------------------------------------------------------------
- (int) getScore
{
    return _scoreValue;
}

// -----------------------------------------------------------------------------------
- (void) setScoreValue:(int)newScore
{
    _scoreValue = newScore;
}

// -----------------------------------------------------------------------------------
- (void) setHighScore
{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:_scoreValue forKey:@"highScore"];
    [standardUserDefaults synchronize];
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
