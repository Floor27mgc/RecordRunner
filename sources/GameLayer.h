//
//  GameLayer.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameObjectPlayer.h"
#import "Coin.h"
#import "Bomb.h"
#import "Queue.h"
#import "Score.h"
#import "GameOverLayer.h"

#define NUM_OBSTACLES            20
#define NUM_REWARDS              20
#define RANDOM_MAX              100
#define BOMB_CREATION_THRESHOLD  97
#define COIN_CREATION_THRESHOLD  90
#define MIN_NUM_BOMBS_PER_TRACK   5
#define MIN_NUM_COINS_PER_TRACK   5
#define MAX_NUM_TRACK             4
typedef enum {
    SPACE_TYPE,
    BOMB_TYPE,
    COIN_TYPE
} game_object_t;

typedef enum {
    kRotation,
    kHeartPumping
} effect_type_t;

@class GameObjectInjector;
// GameLayer
@interface GameLayer : CCLayer
{

}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

// handle "game over" scenario
- (void) gameOver;

// restart the game
- (void) startOver;

// check and update the high score
- (bool) updateHighScore;

// reset high score to zero
- (void) resetHighScore;

// add Power to the layer
- (void) addPower:(id) newPower;

// add PowerIcon to layer, if condition has occurred
- (void) triggerPowerIcons;

// reset Used and Free pools
- (void) resetPoolsWithUsedPool:(Queue *)usedPool
                       freePool:(Queue *)freePool;

@property (nonatomic, strong) GameObjectPlayer *player;

@property (nonatomic, strong) Queue * bombFreePool;
@property (nonatomic, strong) Queue * bombUsedPool;
@property (nonatomic, strong) Queue * coinFreePool;
@property (nonatomic, strong) Queue * coinUsedPool;
@property (nonatomic, strong) Queue * powerPool;
@property (nonatomic, strong) Queue * powerIconPool;
@property (nonatomic, strong) CCSprite *background;
@property (nonatomic, strong) Score * score;
@property (nonatomic, strong) Score * highScore;
@property (nonatomic, strong) GameObjectInjector * gameObjectInjector;
@property (nonatomic, strong) GameOverLayer * gameOverLayer;
@property (nonatomic, strong) CCParticleSystemQuad *playerOnFireEmitter;
@end
