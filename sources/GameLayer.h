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

#define NUM_OBSTACLES            20
#define NUM_REWARDS              20
#define RANDOM_MAX              100
#define BOMB_CREATION_THRESHOLD  97
#define COIN_CREATION_THRESHOLD  90
#define MAX_NUM_BOMBS           100
#define MAX_NUM_COINS           100

typedef enum {
    BOMB_TYPE,
    COIN_TYPE
} game_object_t;

// GameLayer
@interface GameLayer : CCLayer
{
//    GameObjectPlayer *player;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

// randomly create coins and bombs
- (void) generateGameObject:(game_object_t) type;

// accessor to increment score
//- (void) incrementScore:(int) value;
// accessor to decrement score
//- (void) decrementScore:(int) value;

@property (nonatomic, strong) GameObjectPlayer *player;

@property (nonatomic, strong) Queue * bombFreePool;
@property (nonatomic, strong) Queue * bombUsedPool;
@property (nonatomic, strong) Queue * coinFreePool;
@property (nonatomic, strong) Queue * coinUsedPool;
@property (nonatomic, strong) CCSprite *background;
@property (nonatomic, strong) Score * score;

@end
