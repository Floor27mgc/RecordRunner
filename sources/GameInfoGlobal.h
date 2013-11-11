//
//  GameInfoGlobal.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import <Foundation/Foundation.h>
#import "StatisticsContainer.h"
#import "PowerUpEngine.h"

#define NUM_ROUND_TRIGGER_LIKE_ME 12
#define SCORE_TRIGGER_LIKE_ME     600
#define MAX_NAME_LENGTH           128
#define NUM_FRIENDS_TO_COUNT      3

typedef enum {
    kGameModeNormal = 0,
    kGameModeRotatingPlayer,
    kGameModeBouncyMusic
} ENUM_GAME_MODE_T;

typedef struct {
    char name[MAX_NAME_LENGTH];
    int  score;
} gameCenterFriendScore;

typedef struct {
    gameCenterFriendScore friendScores[NUM_FRIENDS_TO_COUNT];
} topNFriends;

@interface GameInfoGlobal : NSObject

- (void) resetPerLifeStatistics;
- (void) logLifeTimeAchievements;
- (void) evaluateSoundPrefrence;
- (void) setMusic: (BOOL) musicSetting;
- (void) setSound: (BOOL) soundSetting;
- (void) ResetLifetimeAchievementData;
- (BOOL) WithdrawCoinsFromBank: (int) numCoins;
- (BOOL) AddCoinsToBank:(int)numCoins;
- (void) ResetFriendsScores;
- (int) NumPowersSelected;


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
@property (nonatomic, assign) int lifetimeCoinsEarned;
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
@property (nonatomic, assign) BOOL FacebookLikedAlready;
@property (nonatomic, assign) BOOL isIAPProductListLoaded;
@property (nonatomic, assign) int lifetimeGameLaunched;
// for power up system
@property (nonatomic, strong) PowerUpEngine * powerEngine;
@property (nonatomic, assign) int closeCallMultiplier;
@property (nonatomic, assign) BOOL playerStartsWithShield;
@property (nonatomic, assign) int minMultVal;
@property (nonatomic, assign) BOOL increasedStarSpawnRate;
@property (nonatomic, assign) double changeGameVelocity;
@property (nonatomic, assign) int multiplierCooldownSec;
@property (nonatomic, assign) int coinValue;
@property (nonatomic, strong) NSMutableArray * powerList;

@property (nonatomic) topNFriends topFriendsScores;

@end
