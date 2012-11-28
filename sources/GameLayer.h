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

#define NUM_OBSTACLES            10
#define NUM_REWARDS              10
#define RANDOM_MAX              100
#define BOMB_CREATION_THRESHOLD  95
#define COIN_CREATION_THRESHOLD  80
#define MAX_NUM_BOMBS             7
#define MAX_NUM_COINS             8

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

//
- (void) generateGameObject:(game_object_t) type;

@property (nonatomic, strong) GameObjectPlayer *player;

@property (nonatomic, strong) Queue * bombFreePool;
@property (nonatomic, strong) Queue * bombUsedPool;
@property (nonatomic, strong) Queue * coinFreePool;
@property (nonatomic, strong) Queue * coinUsedPool;
@property (nonatomic, strong) CCSprite *background;

@end
