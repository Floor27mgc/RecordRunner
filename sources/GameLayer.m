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
#import "common.h"
#import "PowerIcon.h"
#import "CCBReader.h"
#import "GameInfoGlobal.h"
#import "GameDebugMenu.h"

#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer
@synthesize player;// = _player;
@synthesize coinFreePool = _coinFreePool;
@synthesize coinUsedPool = _coinUsedPool;
@synthesize bombFreePool = _bombFreePool;
@synthesize bombUsedPool = _bombUsedPool;
@synthesize multiplier = _multiplier;
@synthesize gameObjectInjector;
@synthesize isGameReadyToStart;
@synthesize soundController = _soundController;
@synthesize gameOverLayer;
@synthesize bombSpawnRate;
@synthesize coinSpawnRate;
@synthesize shieldSpawnRate;
@synthesize isDebugMode;
@synthesize score = _score;
@synthesize highScore = _highScore;
@synthesize scoreLabel;
@synthesize invincibleRecord;
@synthesize pendingTaps;
@synthesize tapDelay;// = _tapDelay;
//@synthesize multiplierLabel;


static GameLayer *sharedGameLayer;

+ (GameLayer *) sharedGameLayer
{
    return sharedGameLayer;
}

/*
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
        
        gameOverLayer = nil;
        bombSpawnRate = kBombSpawnRate;
        coinSpawnRate = kCoinSpawnRate;
        shieldSpawnRate = kShieldSpawnRate;
        isDebugMode = NO;

        // create the player
        player = (GameObjectPlayer *)[CCBReader nodeGraphFromFile:@"gameObjectPlayer.ccbi"
                                                             owner:player];
        player.visible = 1;
        player.animationManager = player.userObject;
        player.gameObjectAngularVelocity = 0;//kDefaultGameObjectAngularVelocityInDegree;
        [self addChild: player z:10];
        
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
/*
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"JewelBeat - Follow The Beat.wav"];*/
        }

        // Create Game Object injector to inject Bomb, coins, etc
        gameObjectInjector = [[GameObjectInjector alloc ]init];

        // Create Power Pool
        _powerPool = [Queue initWithMinSize:1];
        
        // Create PowerIcon Pools
        _powerIconFreePool = [Queue initWithMinSize:MIN_NUM_POWER_ICONS_PER_TRACK];
        _powerIconUsedPool = [Queue initWithMinSize:MIN_NUM_POWER_ICONS_PER_TRACK];
        
        // Create Power Icons and add them to the free pool
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<(trackNum+1) * MIN_NUM_BOMBS_PER_TRACK; i++) {
                PowerIcon * powerIcon =
                (PowerIcon *)[CCBReader nodeGraphFromFile:@"GameObjectShield.ccbi"];
                
                powerIcon.tag = gameObjectTag;
                powerIcon.visible = 0;
                powerIcon.gameObjectAngularVelocity = kDefaultGameObjectAngularVelocityInDegree;
                powerIcon.animationManager = powerIcon.userObject;
                powerIcon.type = shield;
                [_powerIconFreePool addObject:powerIcon toTrack:trackNum];
                gameObjectTag++;
                // add power icon to GameLayer
                [self addChild: powerIcon z:10];
            }
        }
        
        // Create and load high score
        _highScore = [Score initWithGameLayer:self imageFileName:@"" objectSpeed:0];
        int tempHighScore =
            [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
        [_highScore setScoreValue:tempHighScore];
        [_highScore prepareScore:@"High Score"];
    
        // Create the actual score label
        _score = [Score initWithGameLayer:self
                            imageFileName:@""
                              objectSpeed:0];
        [_score prepareScore:@"Score"];
        [_score moveBy:ccp(0, -20)];

        _multiplier = (Multiplier *) [CCBReader nodeGraphFromFile:@"multiplier.ccbi"];
        [_multiplier prepare];
        [self addChild:_multiplier z:10];
        _multiplier.position = ccp(160, 240);
        
        // input buffering structures
        pendingTaps = 0;
        self.tapDelay = [NSDate distantFuture];
    }
/*
    [self schedule: @selector(update:)]; */
    
//    [gameObjectInjector injectObjectToTrack:0 atAngle:45 gameObjectType:COIN_TYPE effectType:kRotation];

    return self;
}


- (void) onEnter
{
    [super onEnter];
    
    player.position = ccp(COMMON_SCREEN_CENTER_X + PLAYER_RADIUS_INNER_MOST,
                          COMMON_SCREEN_CENTER_Y);
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
    // input buffering for player movement
    if ([self moveThePlayer]) {
        [self.player changeDirection];
    }
    
    // generate Game Objectsrandomly
    if (arc4random() % RANDOM_MAX <= coinSpawnRate) {
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:COIN_TYPE effectType:kRotation]; 
    }

    // generate Game Objectsrandomly
    if (arc4random() % RANDOM_MAX <= bombSpawnRate) {
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:BOMB_TYPE effectType:kRotation];
    }
    
    // generate Game Objectsrandomly
    int ran = (arc4random() % RANDOM_MAX);
    if ((ran <= shieldSpawnRate) &&
        (arc4random() % 3 == 1) &&
        ([_powerIconUsedPool getObjectCount] == 0)) {
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:POWER_ICON_TYPE effectType:kRotation];
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
    
    // update high score, if needed
    [self updateHighScore];
    [_score showNextFrame];
    [_highScore showNextFrame];
    [_multiplier showNextFrame];
    
    // check if new Power up has been triggered
//    [self triggerPowerIcons];
    
    // update all PowerIcons
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0;
             i < POOL_OBJ_COUNT_ON_TRACK(_powerIconUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_powerIconUsedPool, trackNum)[i] showNextFrame];
        }
    }
    
    // update all Powers
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_powerPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_powerPool, trackNum)[i] runPower];
        }
    }
    
    // Move player to a new location
    [player showNextFrame];
}

-(float) changeGameAngularVelocityByDegree:(float) byDegree
{
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_coinUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_coinUsedPool, trackNum)[i] changeAngularVelocityByDegree:byDegree];
        }
        
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_bombUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_bombUsedPool, trackNum)[i] changeAngularVelocityByDegree:byDegree];
        }
        
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_coinFreePool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_coinFreePool, trackNum)[i] changeAngularVelocityByDegree:byDegree];
        }
        
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_bombFreePool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_bombFreePool, trackNum)[i] changeAngularVelocityByDegree:byDegree];
        }
    }
    
    // update all PowerIcons
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0;
             i < POOL_OBJ_COUNT_ON_TRACK(_powerIconUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_powerIconUsedPool, trackNum)[i] changeAngularVelocityByDegree:byDegree];
        }
        
        for (int i = 0;
             i < POOL_OBJ_COUNT_ON_TRACK(_powerIconFreePool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_powerIconFreePool, trackNum)[i] changeAngularVelocityByDegree:byDegree];
        }
    }
    
    return [self getGameAngularVelocityInDegree];

}

// -----------------------------------------------------------------------------------
- (float) getGameAngularVelocityInDegree;
{
    if (POOL_OBJ_COUNT_ON_TRACK(_coinFreePool,0) != 0) {
        return ((GameObjectBase *) POOL_OBJS_ON_TRACK(_coinFreePool, 0)[0]).gameObjectAngularVelocity;
    } else {
        return ((GameObjectBase *) POOL_OBJS_ON_TRACK(_coinUsedPool, 0)[0]).gameObjectAngularVelocity;
    }
}

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
/*
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
*/
// -----------------------------------------------------------------------------------
- (void) triggerPowerIcons
{ 
    if ([_powerIconUsedPool getObjectCount] == 0) {
        NSLog(@"Triggering Power Icon!");
        
        [gameObjectInjector injectObjectToTrack:(arc4random()%4) atAngle:45 gameObjectType:POWER_ICON_TYPE effectType:kRotation];
    }
}

// -----------------------------------------------------------------------------------
-(void) openDebugMenu
{
    NSLog(@"openeing debug menu");
    //CCNode* gameDebugLayer = [CCBReader nodeGraphFromFile:@"DebugMenuNode.ccbi"];
    GameDebugMenu * debugMenu = (GameDebugMenu *) [CCBReader nodeGraphFromFile:@"DebugMenuNode.ccbi"];
    debugMenu.position = ccp(COMMON_SCREEN_CENTER_X,COMMON_SCREEN_CENTER_Y);
 
    [GameLayer sharedGameLayer].isDebugMode = YES;
    [self addChild:debugMenu z:12];
}

 /*
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
- (BOOL) moveThePlayer
{
    if (pendingTaps <= 0) {
        return NO;
    }
    
    BOOL move = YES;
    
    BOOL playerWillHitBomb = [self.player willHitBomb];
    
    // move if we have the shield
    if (self.player.hasShield) {
        // do nothing
    } else if (!playerWillHitBomb) {
        // do nothing
    } else if (tapDelay != [NSDate distantFuture]) {
        
        // move if the tap delay exceeds the maximum delay
        double elapsedMilliseconds = [tapDelay timeIntervalSinceNow] * -1000.0;
        
        if (elapsedMilliseconds <= TAP_DELAY_THRESHOLD_MSEC) {
            move = NO;
        }
    } else {
        
        // delay tap processing if the player will hit a bomb
        if (tapDelay == [NSDate distantFuture]) {
            tapDelay = [NSDate date];
        }
        
        move = NO;
    }
    
    if (move) {
        tapDelay = [NSDate distantFuture];
        --pendingTaps;
    } else {
        NSLog(@"delaying tap");
    }
    
    return move;
}

// -----------------------------------------------------------------------------------
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:TAPS_STATS] tick];
    
    ++pendingTaps;
    
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

-(int) changeBombSpawnRateBy:(int) amount
{
    if (((bombSpawnRate + amount) != 0) ||
        ((bombSpawnRate + amount) != RANDOM_MAX)){
        bombSpawnRate += amount;
    }
    return bombSpawnRate;
}

-(int) changeCoinSpawnRateBy:(int) amount
{
    if (((coinSpawnRate + amount) != 0) ||
        ((coinSpawnRate + amount) != RANDOM_MAX)){
        coinSpawnRate += amount;
    }
    return coinSpawnRate;
}

-(int) getCoinSpawnRate
{
    return coinSpawnRate;
}

-(int) getBombSpawnRate
{
    return bombSpawnRate;
}

-(int) changeShieldSpawnRateBy:(int) amount
{
    if (((shieldSpawnRate + amount) != 0) ||
        ((shieldSpawnRate + amount) != RANDOM_MAX)){
        shieldSpawnRate += amount;
    }
    return shieldSpawnRate;
}

-(int) getShieldSpawnRate
{
    return shieldSpawnRate;
}

-(void) cleanUpPlayField
{
    int numObjToCleanup;
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        NSLog(@"%d", POOL_OBJ_COUNT_ON_TRACK(_coinUsedPool, trackNum));
        
        numObjToCleanup = POOL_OBJ_COUNT_ON_TRACK(_coinUsedPool, trackNum);
        for (int i = 0; i < numObjToCleanup; i++) {
            [[POOL_OBJS_ON_TRACK(_coinUsedPool, trackNum) lastObject] recycleObjectWithUsedPool:_coinUsedPool
                                                                             freePool:_coinFreePool];
        }
        
        numObjToCleanup = POOL_OBJ_COUNT_ON_TRACK(_bombUsedPool, trackNum);
        for (int i = 0; i < numObjToCleanup; i++) {
            [[POOL_OBJS_ON_TRACK(_bombUsedPool, trackNum) lastObject] recycleObjectWithUsedPool:_bombUsedPool
                                                                             freePool:_bombFreePool];
        }
        
        numObjToCleanup = POOL_OBJ_COUNT_ON_TRACK(_powerIconUsedPool, trackNum);
        for (int i = 0; i < numObjToCleanup; i++) {
            [[POOL_OBJS_ON_TRACK(_powerIconUsedPool, trackNum) lastObject] recycleObjectWithUsedPool:_powerIconUsedPool
                                                                             freePool:_powerIconFreePool];
        }
        
        [self setIsHitStateByTrackNum:trackNum toState:NO];
        [self setHittingObjByTrackNum:trackNum hittingObj:nil];
    }
    [self.multiplier decrementMultiplier:self.multiplier.multiplierValue-1];
}

-(bool) getIsHitStateByTrackNum:(int) trackNum
{
    return ((trackNum < MAX_NUM_TRACK)?isTrackHit[trackNum]:NO);
}

-(void) setIsHitStateByTrackNum:(int) trackNum toState:(bool) state
{
    if (trackNum < MAX_NUM_TRACK) {
        isTrackHit[trackNum] = state;
    }
}

-(void) setHittingObjByTrackNum:(int) trackNum hittingObj:(id) obj
{
    if (trackNum < MAX_NUM_TRACK) {
        whatHitTrack[trackNum] = obj;
    }
}

-(id) getHittingObjByTrackNum:(int) trackNum
{
    return ((trackNum < MAX_NUM_TRACK)?whatHitTrack[trackNum]:nil);
}
@end
