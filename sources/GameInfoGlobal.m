//
//  GameInfoGlobal.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import "GameInfoGlobal.h"

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
        
        // game rotation data
        [self resetPerLifeStatistics];

        score = 0;
        
        scratchesThisRevolution = 0;
        
        coinsThisScratch = 0;
        
        bombsKilledThisShield = 0;
        
        statsContainer = [[StatisticsContainer alloc] init];
    }
    return self;
}

// -----------------------------------------------------------------------------------
- (void) resetPerLifeStatistics
{
    numDegreesRotatedThisLife = 0;
    numRotationsThisLife = 0;
    timeInOuterRingThisLife = 0;
    numCoinsThisLife = 0;
    closeCallsThisLife = 0;
}

@end
