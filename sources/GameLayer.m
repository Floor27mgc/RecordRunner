//
//  GameLayer.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "GameObjectInjector.h"
#import "pattern.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "ccDrawGameLayer.h"
#import "common.h"
#import "PowerIcon.h"
#import "CCBReader.h"
#import "GameInfoGlobal.h"

#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer
@synthesize player;
@synthesize coinFreePool = _coinFreePool;
@synthesize coinUsedPool = _coinUsedPool;
@synthesize bombFreePool = _bombFreePool;
@synthesize bombUsedPool = _bombUsedPool;
@synthesize gameObjectInjector;
@synthesize isGameReadyToStart;
@synthesize soundController = _soundController;

static GameLayer *sharedGameLayer;

+ (GameLayer *) sharedGameLayer
{
    return sharedGameLayer;
}

/*
@synthesize score = _score;
@synthesize highScore = _highScore;

@synthesize background;





@synthesize powerPool = _powerPool;
@synthesize powerIconFreePool = _powerIconFreePool;
@synthesize powerIconUsedPool = _powerIconUsedPool;

@synthesize gameOverLayer = _gameOverLayer;


@synthesize playerOnFireEmitter;
// -----------------------------------------------------------------------------------
// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) sceneWithMode:(int) gameMode
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer nodeWithGameMode:gameMode];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// -----------------------------------------------------------------------------------
// on Create the node with game mode.
+(id) nodeWithGameMode:(int) gameMode
{
    GameLayer *layer = [GameLayer node];
    switch (gameMode)
    {
        case kGameModeNoRotation:
            layer.player.gameObjectAngularVelocity = 0;
            break;
        case kGameModeRotation:
            layer.player.gameObjectAngularVelocity = kDefaultGameObjectAngularVelocityInDegree;
            break;
        default:
            NSLog(@"Invalid game mode being passed in");
    }
    return layer;
}
*/
// -----------------------------------------------------------------------------------
// on "init" you need to initialize your instance
-(id) init
{
    int gameObjectTag = 0;
    
    NSLog(@"GameMode = %d",[GameInfoGlobal sharedGameInfoGlobal].gameMode);
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        isGameReadyToStart = FALSE;
        sharedGameLayer = self;
        
        // Create coin free pool (queue)
        _coinFreePool = [Queue initWithMinSize:MIN_NUM_COINS_PER_TRACK];
        
        // Create coin used pool (queue)
        _coinUsedPool = [Queue initWithMinSize:MIN_NUM_COINS_PER_TRACK];
        
        // Create NUM_REWARDS coins and add them to the free pool
        gameObjectTag = 0;
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<(trackNum+1) * MIN_NUM_BOMBS_PER_TRACK; i++) {
                Coin *_coin = (Coin*)[CCBReader nodeGraphFromFile:@"gameObjectCoin.ccbi"
                                      owner:_coin];
                NSLog(@"%p",_coin.userObject);
                _coin.tag = gameObjectTag;
                _coin.visible = 0;
                _coin.gameObjectAngularVelocity = kDefaultGameObjectAngularVelocityInDegree;
                _coin.animationManager = _coin.userObject;
                [_coinFreePool addObject:_coin toTrack:trackNum];
                gameObjectTag++;
                // add coin to GameLayer
                [self addChild: _coin z:10];
            }
        }


        // Create bomb free pool (queue)
        _bombFreePool = [Queue initWithMinSize:MIN_NUM_BOMBS_PER_TRACK];
        
        // Create bomb used pool (queue)
        _bombUsedPool = [Queue initWithMinSize:MIN_NUM_BOMBS_PER_TRACK];
        
        // Create NUM_OBSTACLES bombs and add them to the free pool
        gameObjectTag = 0;
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<trackNum+1;i++) {
                Bomb *_bomb = (Bomb *)[CCBReader nodeGraphFromFile:@"gameObjectBomb.ccbi"];
                _bomb.tag = gameObjectTag;
                _bomb.visible = 0;
                _bomb.gameObjectAngularVelocity = kDefaultGameObjectAngularVelocityInDegree;
                _bomb.animationManager = _bomb.userObject;
                [_bombFreePool addObject:_bomb toTrack:trackNum];
                gameObjectTag++;
                // add bomb to GameLayer
                [self addChild: _bomb z:10];
            }
        }
        
        if ([GameInfoGlobal sharedGameInfoGlobal].gameMode == kGameModeBouncyMusic) {
            // enable sounds
            _soundController = [SoundController init];
        } else {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"JewelBeat - Follow The Beat.wav"];
        }

        // Create Game Object injector to inject Bomb, coins, etc
        gameObjectInjector = [[GameObjectInjector alloc ]init];
    }
 /*
        self.isTouchEnabled = YES;
        // This is where we create ALL game objects in this game layer
        // This includes gameObjects like bombs, players, background..etc.
        CGSize size = [[CCDirector sharedDirector] winSize];
        NSLog(@"height = %f width = %f", size.height, size.width);
        
        // Create background
        background = [CCSprite spriteWithFile:@"background-white.jpg"];
        background.anchorPoint=ccp(0,0);
        background.position = ccp(0,0);
        [self addChild:background];
        
        ccDrawGameLayer *ccDrawLayer = [[ccDrawGameLayer alloc] init];
        [self addChild:ccDrawLayer];
 
        // Create background music
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"JewelBeat - Follow The Beat.wav"];

        // Create player
        _player = [GameObjectPlayer initWithGameLayer:self
                                        imageFileName:@"player-hd.png"
                                          objectSpeed:0];
        _player.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
        [_player moveTo:PLAYER_START_POSITION];
        
        [self addChild:_player.gameObjectSprite];
        
        // Create bomb free pool (queue)
        _bombFreePool = [Queue initWithMinSize:MIN_NUM_BOMBS_PER_TRACK];
        
        // Create bomb used pool (queue)
        _bombUsedPool = [Queue initWithMinSize:MIN_NUM_BOMBS_PER_TRACK];
       
        // Create NUM_OBSTACLES bombs and add them to the free pool
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<trackNum+1;i++) {
                Bomb * _bomb = [Bomb initWithGameLayer: self
                                         imageFileName:@"bomb-hd.png"
                                           objectSpeed:kDefaultGameObjectAngularVelocityInDegree];
                _bomb.gameObjectSprite.visible = 0;
                [_bombFreePool addObject:_bomb toTrack:trackNum];
                
                // add bomb to GameLayer
                [self addChild: _bomb.gameObjectSprite];
            }
        }
        
        // Create coin free pool (queue)
        _coinFreePool = [Queue initWithMinSize:MIN_NUM_COINS_PER_TRACK];
        
        // Create coin used pool (queue)
        _coinUsedPool = [Queue initWithMinSize:MIN_NUM_COINS_PER_TRACK];
        
        // Create NUM_REWARDS coins and add them to the free pool
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<(trackNum+1) * MIN_NUM_BOMBS_PER_TRACK; i++) {
                Coin * _coin = [Coin initWithGameLayer:self
                                         imageFileName:@"coin-hd.png"
                                           objectSpeed:kDefaultGameObjectAngularVelocityInDegree];
                _coin.gameObjectSprite.visible = 0;
                [_coinFreePool addObject:_coin toTrack:trackNum];
                
                // add coin to GameLayer
                [self addChild: _coin.gameObjectSprite];
            }
        }
      
        // Create Power Pool
        _powerPool = [Queue initWithMinSize:1];
        
        // Create PowerIcon Pools
        _powerIconFreePool = [Queue initWithMinSize:MIN_NUM_POWER_ICONS_PER_TRACK];
        _powerIconUsedPool = [Queue initWithMinSize:MIN_NUM_POWER_ICONS_PER_TRACK];
        
        // Create Power Icons and add them to the free pool
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<(trackNum+1) * MIN_NUM_BOMBS_PER_TRACK; i++) {
                PowerIcon * powerIcon =
                [PowerIcon initWithGameLayer:self
                                imageFileName:@"shield.jpg"
                                 objectSpeed:kDefaultGameObjectAngularVelocityInDegree
                                    powerType:shield];
                
                powerIcon.gameObjectSprite.visible = 0;
                [_powerIconFreePool addObject:powerIcon toTrack:trackNum];
                
                // add coin to GameLayer
                [self addChild: powerIcon.gameObjectSprite];
            }
        }
        
        // Create and load high score
        _highScore = [Score initWithGameLayer:self imageFileName:@"" objectSpeed:0];
        int tempHighScore =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
        [_highScore setScoreValue:tempHighScore];
        [_highScore prepareScore:@"High Score"];
        [self addChild:_highScore.score];
        
        // Create score
        _score = [Score initWithGameLayer:self
                            imageFileName:@""
                              objectSpeed:0];
        [_score prepareScore:@"Score"];
        [_score moveBy:ccp(0, -20)];
        [self addChild:_score.score];
        
       
    }

    [self schedule: @selector(update:)]; */
	return self;
}

- (void) onEnter
{
    [super onEnter];
    
    // Schedule a selector that is called every frame
    [self schedule:@selector(update:)];
    
}

- (void) onExit
{
    [super onExit];
    
    // Remove the scheduled selector
    [self unscheduleAllSelectors];
}
// -----------------------------------------------------------------------------------
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"

}


// -----------------------------------------------------------------------------------
- (void) update:(ccTime) dt
{

    [player showNextFrame];
   
    // generate Game Objectsrandomly
    if (arc4random() % RANDOM_MAX <= 5) {
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:COIN_TYPE effectType:kRotation]; 
    }

    // generate Game Objectsrandomly
    if (arc4random() % RANDOM_MAX == 1) {
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:BOMB_TYPE effectType:kRotation];
    }
    
    if ([GameInfoGlobal sharedGameInfoGlobal].gameMode == kGameModeBouncyMusic) {
        // Bounce game object based on sound level
        // Note: we are not performing showNextFrame() here.  We
        //       are simply changing the scale factor of all
        //       objects inside the queue.  We'll let the trigger
        //       loop below to actually perform the showNextFrame()
        [self soundBounceGameObjectUsedPool:_coinUsedPool];
    }
    // Trigger each bomb objects and coin object proceed to
    // show the next frame.  Each object will be responsible
    // for the following task:
    //   1. rendering the next frame
    //   2. detect if there is an encounter with the player
    //      a. If yes, call handle_collision() method
    //      b. If no, check if the object is off screen
    //         1. If yes, hide the object and recycle the
    //            object.
    //         2. If no, no op 
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_coinUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_coinUsedPool, trackNum)[i] showNextFrame];            
        }
        
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_bombUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_bombUsedPool, trackNum)[i] showNextFrame];
        }
    }
    
    /*
    // update high score, if needed
    [self updateHighScore];
    [_score showNextFrame];
    [_highScore showNextFrame];
    
    // check if new Power up has been triggered
    [self triggerPowerIcons];
    
    // update all PowerIcons
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_powerIconUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_powerIconUsedPool, trackNum)[i] showNextFrame];
        }
    }
    
    // update all Powers
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_powerPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_powerPool, trackNum)[i] runPower];
        }
    } */
}

/*
// -----------------------------------------------------------------------------------
- (bool) updateHighScore
{
    if ([_score getScore] >= [_highScore getScore]) {
        [_highScore setScoreValue:([_score getScore])];
        [_highScore setHighScore];
        return YES;
    }
    
    return NO;
}

// -----------------------------------------------------------------------------------
- (int) depositCoinsToBank
{
    int bankBalance = [[NSUserDefaults standardUserDefaults] integerForKey:@"coinBank"];

    bankBalance += [_score getScore];
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:bankBalance forKey:@"coinBank"];
    [standardUserDefaults synchronize];
    
    return bankBalance;
}

// -----------------------------------------------------------------------------------
- (void) resetHighScore
{
    [_highScore setScoreValue:0];
    [_highScore setHighScore];
    [_highScore showNextFrame];
}

// -----------------------------------------------------------------------------------
- (void) addPower:(id)newPower
{
    [_powerPool addObject:newPower];
}

// -----------------------------------------------------------------------------------
- (CGPoint) generateRandomTrackCoords
{ 
    CGPoint randomTrackCoords;
    
    randomTrackCoords.x = COMMON_SCREEN_CENTER_X +
        (COMMON_GRID_WIDTH * (arc4random()%4));
    randomTrackCoords.y = COMMON_SCREEN_CENTER_Y;
    PATTERN_ALIGN_TO_GRID(randomTrackCoords);
    randomTrackCoords.x += COMMON_GRID_WIDTH;

    return randomTrackCoords;
}

// -----------------------------------------------------------------------------------
- (void) triggerPowerIcons
{
    // trigger Power for every Nth coin collected
    if ([_score getScore] % 10 == 0 &&
        [_powerIconUsedPool getObjectCount] == 0) {
        NSLog(@"Triggering Power Icon!");
        
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:POWER_ICON_TYPE effectType:kRotation];
    }
}

// -----------------------------------------------------------------------------------
- (void) gameOver
{
    // update high score, if necessary
    [self updateHighScore];
    
    // cash in coins collected from this round
    int bankSize = [self depositCoinsToBank];
    
    NSString * score = [_score generateScoreString];
    CGSize mainSize = [[CCDirector sharedDirector] winSize];
    
    bool didWin = ([_score getScore] >= [_highScore getScore]);
    
    _gameOverLayer = [GameOverLayer initWithScoreString:score
                                                winSize:mainSize
                                                    gameLayer:self
                                                    highScore:didWin
                                                    bankSize:bankSize];

    // set game over layer's display actions
    id zoomIn  = [CCScaleTo actionWithDuration:0.2 scale:1.25];
    id zoomOut = [CCScaleTo actionWithDuration:0.1 scale:1.0];
       
    // execute the game over layer
    [self addChild:_gameOverLayer z:1];
    [self pauseSchedulerAndActions];
    
    [_gameOverLayer runAction:[CCSequence actions:zoomIn, zoomOut, nil]];
}

// -----------------------------------------------------------------------------------
- (void) startOver
{
    // clear PowerIcon pool
    [self resetPoolsWithUsedPool:_powerIconUsedPool freePool:_powerIconFreePool];
    
    // clear Power pool
    [self resetPool:_powerPool];
    
    // reset bomb pools
    [self resetPoolsWithUsedPool:_bombUsedPool freePool:_bombFreePool];
    
    // reset coin pools
    [self resetPoolsWithUsedPool:_coinUsedPool freePool:_coinFreePool];
    
    // remove gameOverLayer
    id zoomWayOut = [CCScaleTo actionWithDuration:1 scale:0.1];
    [_gameOverLayer runAction:[CCSequence actions: zoomWayOut, nil]];
    
    [self resumeSchedulerAndActions];
}

// -----------------------------------------------------------------------------------
- (void) resetPool:(Queue *)pool
{
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(pool, trackNum); ++i) {
            if ([POOL_OBJS_ON_TRACK(pool, trackNum)[i] respondsToSelector:@selector(resetObject)]) {
                [POOL_OBJS_ON_TRACK(pool, trackNum)[i] resetObject];
            } else if ([POOL_OBJS_ON_TRACK(pool, trackNum)[i]
                        respondsToSelector:@selector(resetPower)]) {
                [POOL_OBJS_ON_TRACK(pool, trackNum)[i] resetPower];
            }
        }
    }
    
    [pool clearTracks];
}

// -----------------------------------------------------------------------------------
- (void) resetPoolsWithUsedPool:(Queue *)usedPool freePool:(Queue *)freePool
{
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        for (int i = 0; i <  POOL_OBJ_COUNT_ON_TRACK(usedPool, trackNum); ++i) {
            GameObjectBase * newObject = nil;
            if (POOL_OBJ_COUNT_ON_TRACK(usedPool, trackNum) < MIN_NUM_BOMBS_PER_TRACK) {
                newObject = [freePool takeObjectFromTrack:trackNum];
                if (newObject != nil) {
                    [freePool addObject:newObject toTrack:trackNum];
                    [newObject resetObject];
                }
            }
        }
    }
}
*/
// -----------------------------------------------------------------------------------
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.player changeDirection];
    
/*CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
    explosion.position = self.position;
    [self.parent addChild:explosion]; */
}
/*
// -----------------------------------------------------------------------------------
- (void) changeGameObjectsSpeed:(Queue *)pool up:(BOOL)speedUp speed:(int)factor
{
    if (factor <= 0) {
        return;
    }
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(pool, trackNum); ++i) {
            GameObjectBase * tempObj = POOL_OBJS_ON_TRACK(pool, trackNum)[i];
            
            if (speedUp) {
                tempObj.gameObjectAngularVelocity++;
            } else {
                tempObj.gameObjectAngularVelocity--;
                
                if (tempObj.gameObjectAngularVelocity == 0) {
                    tempObj.gameObjectAngularVelocity = 1;
                }
            }
        }
    }
}

- (void) speedUpGame
{
    [self changeGameObjectsSpeed:self.bombUsedPool
                              up:YES speed:1];
    
    [self changeGameObjectsSpeed:self.bombFreePool
                              up:YES speed:1];
    
    [self changeGameObjectsSpeed:self.coinUsedPool
                              up:YES speed:1];
    
    [self changeGameObjectsSpeed:self.coinFreePool
                              up:YES speed:1];
    
    [self changeGameObjectsSpeed:self.powerIconUsedPool
                              up:YES speed:1];
    
    [self changeGameObjectsSpeed:self.powerIconFreePool
                              up:YES speed:1];
}

- (void) slowDownGame
{
    [self changeGameObjectsSpeed:self.bombUsedPool
                              up:NO speed:1];
    
    [self changeGameObjectsSpeed:self.bombFreePool
                              up:NO speed:1];
    
    [self changeGameObjectsSpeed:self.coinUsedPool
                              up:NO speed:1];
    
    [self changeGameObjectsSpeed:self.coinFreePool
                              up:NO speed:1];
    
    [self changeGameObjectsSpeed:self.powerIconUsedPool
                              up:NO speed:1];
    
    [self changeGameObjectsSpeed:self.powerIconFreePool
                              up:NO speed:1];
} */

-(void) soundBounceGameObjectUsedPool:(Queue *)gameObjectUsedPool
{
    static int subsetIdx = 1;
    double soundLevel = 0;

    // update sound-related items
    soundLevel = [_soundController updateMeterSamples];
    
    int bounceIdx = 0;
    int previousSubset = 0;
    
    // Percentage chance that we are bounching to a different
    // subset of coins
    if ((arc4random()%100) == 1) {
        previousSubset = subsetIdx;
        subsetIdx = arc4random()%10+1;
    }
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(gameObjectUsedPool, trackNum); ++i) {
            GameObjectBase *gameObject = POOL_OBJS_ON_TRACK(gameObjectUsedPool, trackNum)[i];
            
            if ((previousSubset != 0) && (bounceIdx % previousSubset == 0))
            {
                [gameObject scaleMe:0];
            }
            
            [gameObject scaleMe:((bounceIdx % subsetIdx == 0)?soundLevel:0)];
            bounceIdx ++;
        }
    }
}
@end
