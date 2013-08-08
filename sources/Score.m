//
//  Score.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/8/12.
//
//

#import "Score.h"
#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "iRate.h"
@implementation Score

@synthesize score = _score;
@synthesize scoreValue = _scoreValue;
@synthesize multiplierValue = _multiplierValue;
@synthesize prevScore = _prevScore;


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
}


// -----------------------------------------------------------------------------------
- (void) incrementScore:(int)amount
{
    int currenScoreLevel = _scoreValue / kSpeedUpScoreInterval;

    int multAmt = [GameLayer sharedGameLayer].multiplier.multiplierValue;
    
    _scoreValue += (multAmt * amount);
    
    [GameInfoGlobal sharedGameInfoGlobal].score = _scoreValue;
    
    int newScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    
    if (newScoreLevel < kSpeedUpScoreLevelCeiling)
    {
        if (currenScoreLevel < newScoreLevel)
        {
        }
    }
    
    [[GameLayer sharedGameLayer].scoreLabel
        setString:[NSString stringWithFormat:@"%d", _scoreValue]];
    
    //Hin's debug code
    [[iRate sharedInstance] logEvent:YES];  // Matt, put just this statement
                                            // (without the if) to the appropriate
                                            // place to trigger the rate me thing.
    // End Hin's debug code.
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
    
    [GameInfoGlobal sharedGameInfoGlobal].score = _scoreValue;
    
    int newScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    
    if (newScoreLevel >= 0)
    {
        if (currenScoreLevel > newScoreLevel)
        {
        }
    }
}

// -----------------------------------------------------------------------------------
// simply add amount to score, do not use multiplier
- (void) addToScore:(int)amount
{
    int currenScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    
    _scoreValue += amount;
    
    [GameInfoGlobal sharedGameInfoGlobal].score = _scoreValue;
    
    int newScoreLevel = _scoreValue / kSpeedUpScoreInterval;
    
    if (newScoreLevel < kSpeedUpScoreLevelCeiling)
    {
        if (currenScoreLevel < newScoreLevel)
        {
        }
    }
    
    [[GameLayer sharedGameLayer].scoreLabel
     setString:[NSString stringWithFormat:@"%d", _scoreValue]];
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
    [self showNextFrame];
}

// -----------------------------------------------------------------------------------
+ (int) getHighScore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
}
@end
