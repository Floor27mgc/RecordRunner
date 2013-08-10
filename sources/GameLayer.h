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
#import "scoreMini.h"
#import "GameOverLayer.h"
#import "Power.h"
#import "Multiplier.h"
#import "AchievementContainer.h"
#import "CCBAnimationManager.h"
#import "SoundController.h"
#import "SimpleAudioEngine.h"

#define NUM_OBSTACLES                20
#define NUM_REWARDS                  20
#define RANDOM_MAX                  1000
#define BOMB_CREATION_THRESHOLD      97
#define COIN_CREATION_THRESHOLD      90
#define MIN_NUM_BOMBS_PER_TRACK       5
#define MIN_NUM_COINS_PER_TRACK       5
#define MIN_NUM_SCORES_PER_TRACK      5
#define MIN_NUM_POWER_ICONS_PER_TRACK 1
#define MAX_NUM_TRACK                 4
#define MAX_NUM_BOUNCING_COINS        7
#define kBombSpawnRate 20
#define kCoinSpawnRate 50
#define kShieldSpawnRate 3
#define TAP_DELAY_THRESHOLD_MSEC 62
#define REVOLUTION_BUMP_1 33
#define REVOLUTION_BUMP_2 45
#define REVOLUTION_BUMP_3 78

#define SPEED_INCREASE_AMOUNT   .2
#define SPEED_INCREASE_INTERVAL 22
#define MAX_GAME_SPEED          3.0

#define kGameModeNoRotation 0
#define kGameModeRotation   1
typedef enum {
    SPACE_TYPE,
    BOMB_TYPE,
    COIN_TYPE,
    POWER_ICON_TYPE,
    POWER_TYPE,
    SCORE_TYPE
} game_object_t;


typedef enum {
    small,
    medium,
    large
} display_effect;

typedef enum {
    kRotation,
    kHeartPumping
} effect_type_t;

@class GameObjectInjector;

@interface GameLayer : CCLayer  <CCBAnimationManagerDelegate>
{
    BOOL isTrackHit[MAX_NUM_TRACK];
    id whatHitTrack[MAX_NUM_TRACK];
}

+ (GameLayer *) sharedGameLayer;


// handle game over scenario
-(void) gameOver;

// add PowerIcon to layer, if condition has occurred
-(void) triggerPowerIcons;
-(void) soundBounceGameObjectUsedPool:(Queue *)gameObjectUsedPool;
-(float) changeGameAngularVelocityByDegree:(float) byDegree;
-(float) getGameAngularVelocityInDegree;
-(int) changeBombSpawnRateBy:(int) amount;
-(int) changeCoinSpawnRateBy:(int) amount;
-(int) changeShieldSpawnRateBy:(int) amount;
-(int) getCoinSpawnRate;
-(int) getBombSpawnRate;
-(int) getShieldSpawnRate;
-(void) cleanUpPlayField;
-(bool) getIsHitStateByTrackNum:(int) trackNum;
-(void) setIsHitStateByTrackNum:(int) trackNum toState:(bool) state;
-(void) setHittingObjByTrackNum:(int) trackNum hittingObj:(id) obj;
-(id) getHittingObjByTrackNum:(int) trackNum;
-(void) openDebugMenu;
-(BOOL) moveThePlayer;
-(void) showScoreOnTrack: (int) trackNum message:(NSString *) scoreText displayEffect: (display_effect)dispSize;
-(void) activateInvincible;
-(void) deactivateInvincible;
-(void) checkBonuses;
-(void) showGameOverLayer:(int) score;
-(void) startTheNextRound;
-(void) doTimeBasedGameSpeedUp;
-(void) ConvertBombsToCoins;
-(void) resetHighScore;

@property (nonatomic, strong) GameObjectPlayer *player;
@property (nonatomic, strong) Queue * coinFreePool;
@property (nonatomic, strong) Queue * coinUsedPool;
@property (nonatomic, strong) GameObjectInjector * gameObjectInjector;
@property (nonatomic, assign) Boolean isGameReadyToStart;
@property (nonatomic, strong) Queue * bombFreePool;
@property (nonatomic, strong) Queue * bombUsedPool;
@property (nonatomic, strong) SoundController * soundController;
@property (nonatomic, strong) Queue * powerPool;
@property (nonatomic, strong) Queue * powerIconFreePool;
@property (nonatomic, strong) Queue * powerIconUsedPool;
@property (nonatomic, strong) Queue * scoreFreePool;
@property (nonatomic, strong) Queue * scoreUsedPool;
@property (nonatomic, strong) GameOverLayer * gameOverLayer;
@property (nonatomic, strong) Multiplier * multiplier;
@property (nonatomic, assign) int bombSpawnRate;
@property (nonatomic, assign) int coinSpawnRate;
@property (nonatomic, assign) int shieldSpawnRate;
@property (nonatomic, assign) BOOL isDebugMode;
@property (nonatomic, assign) int pendingTaps;
@property (nonatomic, assign) int startingHighScore;
@property (nonatomic) NSDate * tapDelay;
@property (nonatomic, strong) UIView *leaderBoardView;
@property (nonatomic, strong) UIViewController *leaderBoardViewController;
@property (nonatomic, strong) AchievementContainer * achievementContainer;

@property (nonatomic, strong) CCLabelTTF * scoreLabel;
@property (nonatomic, strong) Score * score;
@property (nonatomic, strong) Score * highScore;
@property (nonatomic, strong) CCSprite * invincibleRecord;

@end
