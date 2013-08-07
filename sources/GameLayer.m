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
#import "GameOverLayer.h"
#import "common.h"
#import "PowerIcon.h"
#import "SoundController.h"
#import "CCBReader.h"
#import "GameInfoGlobal.h"
#import "GameDebugMenu.h"
#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>
#import "CCBAnimationManager.h"
#import "NewsDownloader.h"
#import "iRate.h"
#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer
@synthesize player;
@synthesize coinFreePool = _coinFreePool;
@synthesize coinUsedPool = _coinUsedPool;
@synthesize bombFreePool = _bombFreePool;
@synthesize bombUsedPool = _bombUsedPool;
@synthesize scoreFreePool = _scoreFreePool;
@synthesize scoreUsedPool = _scoreUsedPool;
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
@synthesize leaderBoardView;
@synthesize leaderBoardViewController;
@synthesize tapDelay;
@synthesize achievementContainer;


static GameLayer *sharedGameLayer;

+ (GameLayer *) sharedGameLayer
{
    return sharedGameLayer;
}

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
        // achievement monitoring structures
        achievementContainer = [[AchievementContainer alloc] init];
        
        isGameReadyToStart = FALSE;
        sharedGameLayer = self;
        
        gameOverLayer = nil;
        bombSpawnRate = kBombSpawnRate;
        coinSpawnRate = kCoinSpawnRate;
        shieldSpawnRate = kShieldSpawnRate;
        isDebugMode = NO;
        
        _soundController = [SoundController init];
        
        // create the player
        player = (GameObjectPlayer *)[CCBReader nodeGraphFromFile:@"gameObjectPlayer.ccbi"
                                                            owner:player];
        player.animationManager = player.userObject;
        player.gameObjectAngularVelocity = 0;//kDefaultGameObjectAngularVelocityInDegree;
        [self addChild: player z:11];
        
        // Create coin free pool (queue)
        _coinFreePool = [Queue initWithMinSize:MIN_NUM_COINS_PER_TRACK];
        
        // Create coin used pool (queue)
        _coinUsedPool = [Queue initWithMinSize:MIN_NUM_COINS_PER_TRACK];
        
        // Create NUM_REWARDS coins and add them to the free pool
        gameObjectTag = 0;
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<(trackNum+1) * MIN_NUM_BOMBS_PER_TRACK; i++) {
                Coin *_coin = (Coin*)[CCBReader nodeGraphFromFile:@"gameObjectCoin.ccbi"];
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
        
        
        // Create score free pool (queue)
        _scoreFreePool = [Queue initWithMinSize:MIN_NUM_SCORES_PER_TRACK];
        
        // Create score used pool (queue)
        _scoreUsedPool = [Queue initWithMinSize:MIN_NUM_SCORES_PER_TRACK];
        
        
        // Create NUM_OBSTACLES bombs and add them to the free pool
        gameObjectTag = 0;
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<trackNum+3;i++) {
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
        
        // Create scores and add them to the free pool
        gameObjectTag = 0;
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i < MIN_NUM_SCORES_PER_TRACK; i++) {
                scoreMini *_myScore = (scoreMini *)[CCBReader nodeGraphFromFile:@"scoreMini.ccbi"];
                _myScore.visible = 0;
                _myScore.gameObjectAngularVelocity = 0;
                _myScore.animationManager = _myScore.userObject;
                [_scoreFreePool addObject:_myScore toTrack:trackNum];
                gameObjectTag++;
                // add scores to GameLayer
                [self addChild: _myScore z:10];
            }
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
        _multiplier.position = ccp(COMMON_RECORD_CENTER_X, COMMON_RECORD_CENTER_Y);
        
        // input buffering structures
        pendingTaps = 0;
        
        self.tapDelay = [NSDate distantFuture];
        
        // set up internal achievement tracking mechanisms
        //[achievementContainer LoadInternalAchievements];
        
    }
    return self;
}

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}


// -----------------------------------------------------------------------------------
- (void) onEnter
{
    [super onEnter];
    
    player.position = ccp(COMMON_RECORD_CENTER_X + PLAYER_RADIUS_INNER_MOST,
                          COMMON_RECORD_CENTER_Y);
    player.visible = false;
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"start_game"];
    
    // Schedule a selector that is called every frame
    [self schedule:@selector(update:)];
    
}

// -----------------------------------------------------------------------------------
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
        
        // reset the coin per scratch counter
        [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch = 0;
        
        // tick the scratches per revolution counter
        [GameInfoGlobal sharedGameInfoGlobal].scratchesThisRevolution++;
        
        if ([GameInfoGlobal sharedGameInfoGlobal].scratchesThisRevolution >= 40) {
            [GameInfoGlobal sharedGameInfoGlobal].hit40scratchesInSingleRevolution = YES;
        }
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
    
    // update game rotation data
    [GameInfoGlobal sharedGameInfoGlobal].numDegreesRotatedThisLife += kDefaultGameObjectAngularVelocityInDegree;
    if ([GameInfoGlobal sharedGameInfoGlobal].numDegreesRotatedThisLife > 360) {
        [GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife++;
        [GameInfoGlobal sharedGameInfoGlobal].numDegreesRotatedThisLife -= 360;
        [GameInfoGlobal sharedGameInfoGlobal].scratchesThisRevolution = 0;
        [GameInfoGlobal sharedGameInfoGlobal].lifetimeRevolutions++;
    }
    
    // check for accomplished achievements and log if any achieved
    if ([achievementContainer CheckCurrentAchievements]) {
        [achievementContainer LogAchievements];
    }
    
    // Move player to a new location
    [player showNextFrame];
    
    // check for any non-achievement bonuses that may have been achieved
    [self checkBonuses];
    
    // speed up rotation speed, as necessary, never exceeding the max
    if ([self getGameAngularVelocityInDegree] < MAX_GAME_SPEED) {
        [self doTimeBasedGameSpeedUp];
    }
}

// -----------------------------------------------------------------------------------
- (void) doTimeBasedGameSpeedUp
{
    NSTimeInterval elapsed = [[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                              getCurrentGameTimeElapsed];
    int intElapsed = (int) elapsed;

    // if we've hit an interval, increase the speed accordingly
    if (intElapsed % SPEED_INCREASE_INTERVAL == 0) {
        
        // this will be triggered multiple times per second, make sure to only
        // tick the speed once per interval encountered
        BOOL increaseSpeed = NO;
        
        switch ([GameInfoGlobal sharedGameInfoGlobal].speedUpsThisLife) {
            case 0:
                if (intElapsed == SPEED_INCREASE_INTERVAL) {
                    increaseSpeed = YES;
                }
                break;
            case 1:
                if (intElapsed == SPEED_INCREASE_INTERVAL * 2) {
                    increaseSpeed = YES;
                }
                break;
            case 2:
                if (intElapsed == SPEED_INCREASE_INTERVAL * 3) {
                    increaseSpeed = YES;
                }
                break;
            case 3:
                if (intElapsed == SPEED_INCREASE_INTERVAL * 4) {
                    increaseSpeed = YES;
                }
                break;
            default:
                break;
        }
        
        if (increaseSpeed) {
            [self changeGameAngularVelocityByDegree:SPEED_INCREASE_AMOUNT];
            [GameInfoGlobal sharedGameInfoGlobal].speedUpsThisLife++;
        }
    }
}

// -----------------------------------------------------------------------------------
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
- (void) resetHighScore
{
    [_highScore setScoreValue:0];
    [_highScore setHighScore];
    [_highScore showNextFrame];
}

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
    NSLog(@"opening debug menu");

    GameDebugMenu * debugMenu = (GameDebugMenu *) [CCBReader nodeGraphFromFile:@"DebugMenuNode.ccbi"];
    debugMenu.position = ccp(COMMON_SCREEN_CENTER_X,COMMON_SCREEN_CENTER_Y);
    
    [GameLayer sharedGameLayer].isDebugMode = YES;
    [self addChild:debugMenu z:12];
}

// -----------------------------------------------------------------------------------
- (void) gameOver
{
    NSLog(@"Current Rank: %d", (achievementContainer.currentRank));
    
    [self.multiplier die];
    [player killYourself];
    
    //Stop the music because player is dead
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // update end-of-game statistics
    [[[GameInfoGlobal sharedGameInfoGlobal] statsContainer] writeStats];
    
    // reset the game speed
    if ([GameInfoGlobal sharedGameInfoGlobal].speedUpsThisLife > 0) {
        for (int i = 0;
             i < [GameInfoGlobal sharedGameInfoGlobal].speedUpsThisLife;
             ++i) {
            [self changeGameAngularVelocityByDegree:-(SPEED_INCREASE_AMOUNT)];
        }
    }
    
    [self pauseSchedulerAndActions];
    
    NSLog(@"score %d", [[GameLayer sharedGameLayer].score getScore] );
    
    [self showGameOverLayer: [[GameLayer sharedGameLayer].score getScore] ];
}


// -----------------------------------------------------------------------------------
- (void) checkBonuses
{
    int scoreBump = -1;

    switch ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife) {
        case REVOLUTION_BUMP_1:
            if (![GameInfoGlobal sharedGameInfoGlobal].hit33rotationsThisLife) {
                [GameInfoGlobal sharedGameInfoGlobal].hit33rotationsThisLife = YES;
                scoreBump = REVOLUTION_BUMP_1;
            }
            break;
        case REVOLUTION_BUMP_2:
            if (![GameInfoGlobal sharedGameInfoGlobal].hit45rotationsThisLife) {
                [GameInfoGlobal sharedGameInfoGlobal].hit45rotationsThisLife = YES;
                scoreBump = REVOLUTION_BUMP_2;
            }
            break;
        case REVOLUTION_BUMP_3:
            if (![GameInfoGlobal sharedGameInfoGlobal].hit78rotationsThisLife) {
                [GameInfoGlobal sharedGameInfoGlobal].hit78rotationsThisLife = YES;
                scoreBump = REVOLUTION_BUMP_3;
            }
            break;
        default:
            break;
    }
    
    // display RPM score bump and increment score accordingly
    if (scoreBump != -1) {
        NSString * rpmBump = [NSString stringWithFormat:@"%d revolutions!!!",
                              scoreBump];
        
        [gameObjectInjector showScoreObject:3 message: rpmBump xVal:270 yVal:270 displayEffect:small];
        [_score addToScore:scoreBump];
    }
}

// -----------------------------------------------------------------------------------
- (BOOL) moveThePlayer
{
    if (player.playerRadialSpeed == 0 && pendingTaps > 0) {
        --pendingTaps;
        return YES;
    } else {
        // reset the coins per scratch counter if we're not moving any more
        if (player.playerRadialSpeed == 0 &&
            [player isIdle] &&
            [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch > 0) {
            [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch = 0;
        }
        return NO;
    }
}

// -----------------------------------------------------------------------------------
//This is called by any object that wants to show a score on the board.
- (void) showScoreOnTrack: (int)track message:(NSString *) scoreText displayEffect: (display_effect)dispSize
{
    [gameObjectInjector showScoreObject:track message: scoreText xVal:0 yVal:0 displayEffect:dispSize];
}


// -----------------------------------------------------------------------------------
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:TAPS_STATS] tick];
    
    // the player is moving
    if (player.playerRadialSpeed != 0) {
        
        // buffer the tap, if not already registered
        if (pendingTaps == 0) {
            ++pendingTaps;
        }
    } else {
        // player is not moving
        ++pendingTaps;
    }
    
}

// -----------------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------------
-(int) changeBombSpawnRateBy:(int) amount
{
    if (((bombSpawnRate + amount) != 0) ||
        ((bombSpawnRate + amount) != RANDOM_MAX)){
        bombSpawnRate += amount;
    }
    return bombSpawnRate;
}

// -----------------------------------------------------------------------------------
-(int) changeCoinSpawnRateBy:(int) amount
{
    if (((coinSpawnRate + amount) != 0) ||
        ((coinSpawnRate + amount) != RANDOM_MAX)){
        coinSpawnRate += amount;
    }
    return coinSpawnRate;
}

// -----------------------------------------------------------------------------------
-(int) getCoinSpawnRate
{
    return coinSpawnRate;
}

// -----------------------------------------------------------------------------------
-(int) getBombSpawnRate
{
    return bombSpawnRate;
}

// -----------------------------------------------------------------------------------
-(int) changeShieldSpawnRateBy:(int) amount
{
    if (((shieldSpawnRate + amount) != 0) ||
        ((shieldSpawnRate + amount) != RANDOM_MAX)){
        shieldSpawnRate += amount;
    }
    return shieldSpawnRate;
}

// -----------------------------------------------------------------------------------
-(int) getShieldSpawnRate
{
    return shieldSpawnRate;
}

//This is called when player gets the star so that he is invincible
-(void) activateInvincible
{
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
            //Turn on all the bombs
            for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_bombUsedPool, trackNum); ++i) {
        
                [POOL_OBJS_ON_TRACK(_bombUsedPool, trackNum)[i] makeInvincible];
            }
    }
    
    //Start the countdown
    [self.multiplier setShield];
    
}

-(void) deactivateInvincible
{
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        //Turn off all the bombs
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_bombUsedPool, trackNum); ++i) {
            
            [POOL_OBJS_ON_TRACK(_bombUsedPool, trackNum)[i] makeVincible];
        }
    }

    [self.multiplier resumeMultiCountdown];
}

//Called after pushing "Play" on the GameOverLayer. This does all the stuff to reset the board and get it ready for the next player life
-(void) startTheNextRound
{
    
    [self resumeSchedulerAndActions];
    [self cleanUpPlayField];
    [self.score setScoreValue:0];
    
}


// -----------------------------------------------------------------------------------
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
        
        numObjToCleanup = POOL_OBJ_COUNT_ON_TRACK(_scoreUsedPool, trackNum);
        for (int i = 0; i < numObjToCleanup; i++) {
            [[POOL_OBJS_ON_TRACK(_scoreUsedPool, trackNum) lastObject] recycleObjectWithUsedPool:_scoreUsedPool
                                                                                        freePool:_scoreFreePool];
        }
        
        numObjToCleanup = POOL_OBJ_COUNT_ON_TRACK(_powerIconUsedPool, trackNum);
        for (int i = 0; i < numObjToCleanup; i++) {
            [[POOL_OBJS_ON_TRACK(_powerIconUsedPool, trackNum) lastObject] recycleObjectWithUsedPool:_powerIconUsedPool
                                                                                            freePool:_powerIconFreePool];
        }
        
        [self setIsHitStateByTrackNum:trackNum toState:NO];
        [self setHittingObjByTrackNum:trackNum hittingObj:nil];
    }
    
    [self.multiplier reset];

    
    [[GameLayer sharedGameLayer].gameObjectInjector stopInjector];
    
    CCBAnimationManager* animationManager = self.userObject;
    player.visible = false;
    
    
    [animationManager runAnimationsForSequenceNamed:@"start_game"];
    
}

// -----------------------------------------------------------------------------------
-(bool) getIsHitStateByTrackNum:(int) trackNum
{
    return ((trackNum < MAX_NUM_TRACK)?isTrackHit[trackNum]:NO);
}

// -----------------------------------------------------------------------------------
-(void) setIsHitStateByTrackNum:(int) trackNum toState:(bool) state
{
    if (trackNum < MAX_NUM_TRACK) {
        isTrackHit[trackNum] = state;
    }
}

// -----------------------------------------------------------------------------------
-(void) setHittingObjByTrackNum:(int) trackNum hittingObj:(id) obj
{
    if (trackNum < MAX_NUM_TRACK) {
        whatHitTrack[trackNum] = obj;
    }
}

// -----------------------------------------------------------------------------------
-(id) getHittingObjByTrackNum:(int) trackNum
{
    return ((trackNum < MAX_NUM_TRACK)?whatHitTrack[trackNum]:nil);
}

// -----------------------------------------------------------------------------------
-(void) startTheMusic
{
    //Check based on music setting
    if ([GameInfoGlobal sharedGameInfoGlobal].isBackgroundMusicOn)
    {
        //Start the music for the game, the player is starting.
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"loop1.caf"];
    }
}




//Called after the game is over, it shows the dialog. Also called after the RankLayerBox
- (void) showGameOverLayer: (int) score
{
    
    if (gameOverLayer != nil)
    {
        CCBAnimationManager* animationManager = gameOverLayer.userObject;
        NSLog(@"animationManager: %@", animationManager);
        
        
        //This sets the menu data for the final menu
        [gameOverLayer setMenuData: score];
         
         
        gameOverLayer.visible = YES;
        [animationManager runAnimationsForSequenceNamed:@"Pop in"];
    } else {
        gameOverLayer =
        (GameOverLayer *) [CCBReader nodeGraphFromFile:@"GameOverLayerBox.ccbi"];
        gameOverLayer.position = COMMON_SCREEN_CENTER;
        
        //This sets the menu data for the final menu
        [gameOverLayer setMenuData: score];
        
        [[GameLayer sharedGameLayer] addChild:gameOverLayer z:11];
    }
    
    
    [[[GameInfoGlobal sharedGameInfoGlobal] statsContainer] resetGameTimer];

}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    
    //After the starting animation completes, hide the fall fake player:
    if ([name compare:@"player_fall"] == NSOrderedSame)
    {
        NSLog(@"start game");
        [self.player startPlayer];

       
        //This is a little hack to hide the fake player animation that shows at the start of the game.  
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"player_fall_hide"];
    }
    if ([name compare:@"player_fall_hide"] == NSOrderedSame)
    {
        //This will give a few seconds just to let the players realize what is happening before we start injecting. If you want to make this longer, add time to player_fall_hide
        [self.gameObjectInjector startInjector];
        [self startTheMusic];
    }
    
}

@end
