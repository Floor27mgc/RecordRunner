//
//  GameInfoGlobal.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import "GameInfoGlobal.h"
#import <AudioToolbox/AudioSession.h>
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
        
        bombsKilledThisShield = 0;
        
        coinsInBank = [[NSUserDefaults standardUserDefaults] integerForKey:@"coinBank"];
        
        lifetimeRevolutions =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"lifetimeRevolutions"];
        
        lifetimeRoundsPlayed =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"lifetimeRoundsPlayed"];
        
        NSLog(@"Coin bank %d lifetimeRevolutions %d lifetimeRoundsPlayed %d", coinsInBank,
              lifetimeRevolutions, lifetimeRoundsPlayed);
        
        achievedThisRound = [[NSMutableArray alloc] init];
        
        statsContainer = [[StatisticsContainer alloc] init];
        
        AudioSessionInitialize(NULL,NULL,NULL,NULL);
        [self evaluateSoundPrefrence];
        
        // game rotation data
        [self resetPerLifeStatistics];
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
    [achievedThisRound removeAllObjects];
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
        isSoundEffectOn = 0;
        isBackgroundMusicOn = 0;
    }
    else
    {
        // Matt, please fix this.  Need to set it based on persistence area.
        isSoundEffectOn = 1;
        isBackgroundMusicOn = 1;
    }
}

@end
