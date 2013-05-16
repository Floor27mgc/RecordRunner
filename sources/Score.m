//
//  Score.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/8/12.
//
//

#import "Score.h"
#import "GameLayer.h"

@implementation Score

@synthesize score = _score;
@synthesize scoreValue = _scoreValue;
@synthesize prevScore = _prevScore;
//@synthesize label = _label;
/*@synthesize multiplier = _multiplier;
@synthesize timerLifeInSec = _timerLifeInSec;
@synthesize multiplierTime = _multiplierTime;*/

// -----------------------------------------------------------------------------------
- (id) init
{
    _scoreValue = 0;
    _prevScore  = 0;
/*    _multiplier = 1;
    _timerLifeInSec = 0;
    _multiplierTime = [NSDate distantFuture];;*/
    
    if(self = [super init]) {

    }

    return (self);
}

// -----------------------------------------------------------------------------------
- (void) prepareScore:(NSString *) myLabel
{
    //_label = myLabel;
    //_score = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFontTest.fnt"];
    //NSString * scoreString = [self generateScoreString];
    //[_score setString:scoreString];
   // CGSize size = [[CCDirector sharedDirector] winSize];
   // _score.position = ccp(kScorePositionX,kScorePositionY);
}


// -----------------------------------------------------------------------------------
- (void) incrementScore:(int)amount
{
    int currenScoreLevel = _scoreValue / kSpeedUpScoreInterval;

    int multAmt = [GameLayer sharedGameLayer].multiplier.multiplierValue;
    
    _scoreValue += (multAmt * amount);
    
    int newScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    
    if (newScoreLevel < kSpeedUpScoreLevelCeiling)
    {
        if (currenScoreLevel < newScoreLevel)
        {
            //[[GameLayer sharedGameLayer] speedUpGame];
        }
    }
    
    [[GameLayer sharedGameLayer].scoreLabel
        setString:[NSString stringWithFormat:@"%d", _scoreValue]];
}

// -----------------------------------------------------------------------------------
- (void) decrementScore:(int)amount
{
    int currenScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    if (amount > _scoreValue) {
        _scoreValue = 0;
    } else {
        _scoreValue -= amount;
    }
    int newScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    
    if (newScoreLevel >= 0)
    {
        if (currenScoreLevel > newScoreLevel)
        {
            //[[GameLayer sharedGameLayer] slowDownGame];
        }
    }
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
    [[GameLayer sharedGameLayer].scoreLabel
     setString:[NSString stringWithFormat:@"%d", _scoreValue]];
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
        _prevScore = _scoreValue;
    }
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    _scoreValue = 0;
    //_multiplier = 1;
    [self showNextFrame];
}

@end
