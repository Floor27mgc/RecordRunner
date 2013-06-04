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

+ (GameInfoGlobal *) sharedGameInfoGlobal;
@property (nonatomic,assign) ENUM_GAME_MODE_T gameMode;
@property (nonatomic, strong) StatisticsContainer * statsContainer;

@property (nonatomic,assign) float gameObjectAngularVelocityInDegree;
@property (nonatomic,assign) int bombSpawnRate;
@property (nonatomic,assign) int coinSpawnRate;
@property (nonatomic,assign) int shieldSpawnRate;
@property (nonatomic, assign) int numRotations;
@property (nonatomic, assign) int numDegreesRotated;
@property (nonatomic, assign) int numCoins;
@property (nonatomic, assign) int closeCalls;
@property (nonatomic, assign) int score;

@end
