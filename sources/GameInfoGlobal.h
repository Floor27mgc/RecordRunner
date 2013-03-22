//
//  GameInfoGlobal.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import <Foundation/Foundation.h>
typedef enum {
    kGameModeNormal = 0,
    kGameModeRotatingPlayer,
    kGameModeBouncyMusic
} ENUM_GAME_MODE_T;

@interface GameInfoGlobal : NSObject

+ (GameInfoGlobal *) sharedGameInfoGlobal;
@property (nonatomic,assign) ENUM_GAME_MODE_T gameMode;
@property (nonatomic,assign) float gameObjectAngularVelocityInDegree;
@property (nonatomic,assign) int bombSpawnRate;
@property (nonatomic,assign) int coinSpawnRate;
@property (nonatomic,assign) int shieldSpawnRate;
@end
