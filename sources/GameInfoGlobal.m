//
//  GameInfoGlobal.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import "GameInfoGlobal.h"
#import <AudioToolbox/AudioSession.h>
#import "iRate.h"
#import "GameLayer.h"

@implementation GameInfoGlobal
@synthesize gameMode;
@synthesize statsContainer;

@synthesize gameObjectAngularVelocityInDegree;
@synthesize bombSpawnRate;
@synthesize coinSpawnRate;
@synthesize shieldSpawnRate;
@synthesize numRotationsThisLife;
@synthesize numDegreesRotatedThisLife;
@synthesize numCoinsThisLife;
@synthesize closeCallsThisLife;
@synthesize score;
@synthesize scratchesThisRevolution;
@synthesize coinsThisScratch;
@synthesize bombsKilledThisShield;
@synthesize timeInOuterRingThisLife;
@synthesize coinsInBank;
@synthesize lifetimeRevolutions;
@synthesize lifetimeRoundsPlayed;
@synthesize hit40scratchesInSingleRevolution;
@synthesize isBackgroundMusicOn;
@synthesize isSoundEffectOn;
@synthesize achievedThisRound;
@synthesize hit33rotationsThisLife;
@synthesize hit45rotationsThisLife;
@synthesize hit78rotationsThisLife;
@synthesize speedUpsThisLife;
@synthesize maxCoinsPerScratch;
@synthesize clockwiseThenCounterclockwise;
@synthesize maxNumRevolutionsInALife;
@synthesize powerEngine;
@synthesize closeCallMultiplier;
@synthesize playerStartsWithShield;
@synthesize minMultVal;
@synthesize changeGameVelocity;
@synthesize multiplierCooldownSec;
@synthesize powerList;

static GameInfoGlobal *sharedGameInfoGlobal;

+ (GameInfoGlobal *) sharedGameInfoGlobal
{
    return sharedGameInfoGlobal;
}

// -----------------------------------------------------------------------------------
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        sharedGameInfoGlobal = self;
        gameMode = kGameModeNormal;

        score = 0;
        
        scratchesThisRevolution = 0;
        
        coinsThisScratch = 0;
        
        hit40scratchesInSingleRevolution = NO;
        
        clockwiseThenCounterclockwise = NO;
        
        bombsKilledThisShield = 0;
        
        maxCoinsPerScratch = 0;
        
        coinsInBank = [[NSUserDefaults standardUserDefaults] integerForKey:@"coinBank"];
        
        lifetimeRevolutions =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"lifetimeRevolutions"];
        
        lifetimeRoundsPlayed =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"lifetimeRoundsPlayed"];
        
        maxNumRevolutionsInALife =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"maxRevolutionsInALife"];
        
        NSLog(@"Coin bank %d lifetimeRevolutions %d lifetimeRoundsPlayed"
              "%d maxRevolutionsInALife %d",
              coinsInBank, lifetimeRevolutions, lifetimeRoundsPlayed,
              maxNumRevolutionsInALife);
        
        achievedThisRound = [[NSMutableArray alloc] init];
        
        statsContainer = [[StatisticsContainer alloc] init];
        
        AudioSessionInitialize(NULL,NULL,NULL,NULL);
        [self evaluateSoundPrefrence];
        
        // game rotation data
        [self resetPerLifeStatistics];
        
        // power up system initialization
        powerEngine = [[PowerUpEngine alloc] init];
        [powerEngine ResetPowerUps];
        
        //Fill the power list
        powerList = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt: BLANK_SPACE], [NSNumber numberWithInt: BLANK_SPACE], [NSNumber numberWithInt: BLANK_SPACE], nil];
        
//        if (lifetimeRoundsPlayed > TRIGGER_LIKE_ME) {
//            [[iRate sharedInstance] logEvent:NO];
//        }
    }
    return self;
}

// -----------------------------------------------------------------------------------
- (void) logLifeTimeAchievements
{
    // deposit the coins
    [GameInfoGlobal sharedGameInfoGlobal].coinsInBank +=
        [GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:coinsInBank forKey:@"coinBank"];
    
    // update the lifetime revolution
    [standardUserDefaults setInteger:lifetimeRevolutions forKey:@"lifetimeRevolutions"];
    
    // update the lifetime revolution
    [standardUserDefaults setInteger:lifetimeRoundsPlayed forKey:@"lifetimeRoundsPlayed"];

    // update the max number of revolutions achieved in a life
    [standardUserDefaults setInteger:maxNumRevolutionsInALife forKey:@"maxRevolutionsInALife"];
    
    [standardUserDefaults synchronize];
    
    if ((lifetimeRoundsPlayed > NUM_ROUND_TRIGGER_LIKE_ME) &&
        ([GameLayer sharedGameLayer].score.scoreValue > SCORE_TRIGGER_LIKE_ME))
    {
        [iRate sharedInstance].messageTitle = @" ";
        [iRate sharedInstance].message = [NSString stringWithFormat:@"Awesome score %d! Would you like to rate Rotato?",[GameLayer sharedGameLayer].score.scoreValue];
        [[iRate sharedInstance] logEvent:NO];
    }
}

// -----------------------------------------------------------------------------------
- (void) ResetLifetimeAchievementData
{
    // deposit the coins
    [GameInfoGlobal sharedGameInfoGlobal].coinsInBank = 0;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:coinsInBank forKey:@"coinBank"];
    
    // update the lifetime revolution
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRevolutions = 0;
    [standardUserDefaults setInteger:lifetimeRevolutions forKey:@"lifetimeRevolutions"];
    
    // update the lifetime rounds played
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed = 0;
    [standardUserDefaults setInteger:lifetimeRoundsPlayed forKey:@"lifetimeRoundsPlayed"];
    
    // update the lifetime max revolutions
    [GameInfoGlobal sharedGameInfoGlobal].maxNumRevolutionsInALife = 0;
    [standardUserDefaults setInteger:maxNumRevolutionsInALife forKey:@"maxRevolutionsInALife"];
    
    [standardUserDefaults synchronize];
}

// -----------------------------------------------------------------------------------
- (void) resetPerLifeStatistics
{
    numDegreesRotatedThisLife = 0;
    numRotationsThisLife = 0;
    timeInOuterRingThisLife = 0;
    numCoinsThisLife = 0;
    closeCallsThisLife = 0;
    speedUpsThisLife = 0;
    [achievedThisRound removeAllObjects];
    hit33rotationsThisLife = NO;
    hit45rotationsThisLife = NO;
    hit78rotationsThisLife = NO;
}

// -----------------------------------------------------------------------------------
-(void) evaluateSoundPrefrence
{
    UInt32 propertySize, audioIsAlreadyPlaying=0;
    propertySize = sizeof(UInt32);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &audioIsAlreadyPlaying);
    
    if (audioIsAlreadyPlaying)
    {
        // if something else is playing the sound, we are muting the game.
        isSoundEffectOn = NO;
        isBackgroundMusicOn = NO;
    }
    else
    {
        // Matt, please fix this.  Need to set it based on persistence area.
        isSoundEffectOn = YES;
        isBackgroundMusicOn = YES;
    }
}

// -----------------------------------------------------------------------------------
-(void) setMusic: (BOOL) musicSetting
{
    isBackgroundMusicOn = musicSetting;
}

// -----------------------------------------------------------------------------------
- (void) setSound: (BOOL) soundSetting
{
    isSoundEffectOn = soundSetting;
}

// -----------------------------------------------------------------------------------
// Called when you unpurchase something. Typically when you click the circle at the top.
- (BOOL) AddCoinsToBank:(int)numCoins
{

    // withdraw the coins from the bank and synchronize the persistent data
    coinsInBank += numCoins;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:coinsInBank forKey:@"coinBank"];
    
    [standardUserDefaults synchronize];
    
    return YES;
}


// -----------------------------------------------------------------------------------
- (BOOL) WithdrawCoinsFromBank:(int)numCoins
{
    // sanity checks
    if (numCoins < 0) {
        return NO;
    }
    
    if (numCoins > coinsInBank) {
        return NO;
    }
    
    // withdraw the coins from the bank and synchronize the persistent data
    coinsInBank -= numCoins;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setInteger:coinsInBank forKey:@"coinBank"];
    
    [standardUserDefaults synchronize];
    
    return YES;
}

@end
