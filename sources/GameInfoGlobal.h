//
//  GameInfoGlobal.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import <Foundation/Foundation.h>
#import "StatisticsContainer.h"

#define NUM_ROUND_TRIGGER_LIKE_ME 12
#define SCORE_TRIGGER_LIKE_ME     1000

typedef enum {
    kGameModeNormal = 0,
    kGameModeRotatingPlayer,
    kGameModeBouncyMusic
} ENUM_GAME_MODE_T;

@interface GameInfoGlobal : NSObject

- (void) resetPerLifeStatistics;
- (void) logLifeTimeAchievements;
- (void) evaluateSoundPrefrence;
- (void) setMusic: (BOOL) musicSetting;
- (void) setSound: (BOOL) soundSetting;
- (void) ResetLifetimeAchievementData;

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
@property (nonatomic, assign) int maxNumRevolutionsInALife;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int scratchesThisRevolution;
@property (nonatomic, assign) int coinsThisScratch;
@property (nonatomic, assign) int maxCoinsPerScratch;
@property (nonatomic, assign) int bombsKilledThisShield;
@property (nonatomic, assign) int timeInOuterRingThisLife;
@property (nonatomic, assign) int coinsInBank;
@property (nonatomic, assign) int lifetimeRevolutions;
@property (nonatomic, assign) int lifetimeRoundsPlayed;
@property (nonatomic, assign) BOOL hit40scratchesInSingleRevolution;
@property (nonatomic, assign) BOOL isBackgroundMusicOn;
@property (nonatomic, assign) BOOL isSoundEffectOn;
@property (nonatomic, strong) NSMutableArray * achievedThisRound;
@property (nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL hit33rotationsThisLife;
@property (nonatomic, assign) BOOL hit45rotationsThisLife;
@property (nonatomic, assign) BOOL hit78rotationsThisLife;
@property (nonatomic, assign) int speedUpsThisLife;
@property (nonatomic, assign) BOOL clockwiseThenCounterclockwise;

@end
