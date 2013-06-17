//
//  GameInfoGlobal.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import <Foundation/Foundation.h>
#import "StatisticsContainer.h"

typedef enum {
    kGameModeNormal = 0,
    kGameModeRotatingPlayer,
    kGameModeBouncyMusic
} ENUM_GAME_MODE_T;

@interface GameInfoGlobal : NSObject

- (void) resetPerLifeStatistics;

+ (GameInfoGlobal *) sharedGameInfoGlobal;
@property (nonatomic,assign) ENUM_GAME_MODE_T gameMode;
@property (nonatomic, strong) StatisticsContainer * statsContainer;

@property (nonatomic,assign) float gameObjectAngularVelocityInDegree;
@property (nonatomic,assign) int bombSpawnRate;
@property (nonatomic,assign) int coinSpawnRate;
@property (nonatomic,assign) int shieldSpawnRate;
@property (nonatomic, assign) int numRotationsThisLife;
@property (nonatomic, assign) int numDegreesRotatedThisLife;
@property (nonatomic, assign) int numCoinsThisLife;
@property (nonatomic, assign) int closeCallsThisLife;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int scratchesThisRevolution;
@property (nonatomic, assign) int coinsThisScratch;
@property (nonatomic, assign) int bombsKilledThisShield;
@property (nonatomic, assign) int timeInOuterRingThisLife;

@end
