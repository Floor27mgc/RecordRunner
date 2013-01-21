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
#import "Power.h"
#import "PowerIcon.h"

#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer
@synthesize player = _player;

@synthesize score = _score;
@synthesize highScore = _highScore;

@synthesize background;

@synthesize bombFreePool = _bombFreePool;
@synthesize bombUsedPool = _bombUsedPool;

@synthesize coinFreePool = _coinFreePool;
@synthesize coinUsedPool = _coinUsedPool;

@synthesize powerPool = _powerPool;
@synthesize powerIconPool = _powerIconPool;

@synthesize gameOverLayer = _gameOverLayer;

@synthesize gameObjectInjector;
@synthesize playerOnFireEmitter;
// -----------------------------------------------------------------------------------
// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// -----------------------------------------------------------------------------------
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
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
                                          objectSpeed:kDefaultGameObjectAngularVelocityInDegree];
        _player.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
        [_player moveTo:PLAYER_START_POSITION];

//        self.playerOnFireEmitter = [CCParticleSystemQuad particleWithFile:@"PlayerOnFire.plist"];
        
//        [self addChild:playerOnFireEmitter z:10];
        
        [self addChild:_player.gameObjectSprite];
        
        // Create bomb free pool (queue)
        _bombFreePool = [Queue initWithMinSize:MIN_NUM_BOMBS_PER_TRACK];
        
        // Create bomb used pool (queue)
        _bombUsedPool = [Queue initWithMinSize:MIN_NUM_BOMBS_PER_TRACK];
       
        // Create NUM_OBSTACLES bombs and add them to the free pool
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            for (int i=0; i<(trackNum+1) * MIN_NUM_BOMBS_PER_TRACK; i++) {
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
            for (int i=0; i<(trackNum+1) * MIN_NUM_COINS_PER_TRACK; i++) {
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
        _powerPool = [Queue initWithSize:0];
        
        // Create PowerIcon Pool
        _powerIconPool = [Queue initWithSize:0];
        
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
        
        // Create Game Object injector to inject Bomb, coins, etc
        gameObjectInjector = [GameObjectInjector initWithGameLayer:self];        
    }

    [self schedule: @selector(update:)];
	return self;
}

- (void) draw
{
    glLineWidth(2);
    ccDrawColor4B(255, 0, 0, 255);
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        ccDrawCircle(COMMON_SCREEN_CENTER, (trackNum+1)*COMMON_GRID_WIDTH, 0, 50, NO);
    }
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
    [_player showNextFrame];
    
    // generate Game Objectsrandomly
    if (arc4random() % RANDOM_MAX == 1) {
        
//        [gameObjectInjector injectObjectWithPattern:(arc4random() % patternNumPattern())
//                                   initialXPosition:COMMON_SCREEN_CENTER];
//        [gameObjectInjector injectObjectWithPattern:1
//                                   initialXPosition:COMMON_SCREEN_CENTER];
        int offsetX = COMMON_SCREEN_CENTER_X + (COMMON_GRID_WIDTH * (arc4random()%4));
        [gameObjectInjector injectObjectAt:ccp(offsetX,COMMON_SCREEN_CENTER_Y) gameObjectType:2 effectType:kRotation];

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
    for (int trackNum=0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_coinUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_coinUsedPool, trackNum)[i] showNextFrame];
//            [_coinUsedPool getObjectArray:_TRACKNUM];
//            [_coinFreePool getObjectArray:trackNum];
        }
        
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(_bombUsedPool, trackNum); ++i) {
            [POOL_OBJS_ON_TRACK(_bombUsedPool, trackNum)[i] showNextFrame];
        }
    }
    
    // update high score, if needed
    [self updateHighScore];
    [_score showNextFrame];
    [_highScore showNextFrame];
    
    // check if new Power up has been triggered
    [self triggerPowerIcons];
    
    // update all PowerIcons
    for (int i = 0; i < [_powerIconPool.objects count]; ++i) {
        [_powerIconPool.objects[i] showNextFrame];
    }
    
    // update all Powers
    for (int i = 0; i < [_powerPool.objects count]; ++i) {
        [_powerPool.objects[i] runPower];
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
- (void) addPower:(id)newPower
{
    [_powerPool addObject:newPower];
}

// -----------------------------------------------------------------------------------
- (void) triggerPowerIcons
{
    // trigger Power for every Nth coin collected
    if ([_score getScore] % 10 == 0 &&
        [_powerIconPool.objects count] == 0) {
        PowerIcon * newPower = [PowerIcon initWithGameLayer:self
                                              imageFileName:@"missle_icon.png" objectSpeed:2
                                                  powerType:fire_missle];

        CGPoint iconLoc;
        iconLoc.x = arc4random_uniform([[CCDirector sharedDirector] winSize].width);
        iconLoc.y = 0;
        [newPower moveTo:iconLoc];
        [self addChild:newPower.gameObjectSprite];
        [_powerIconPool addObject:newPower];
    }
}

// -----------------------------------------------------------------------------------
- (void) gameOver
{
    // update high score, if necessary
    [self updateHighScore];
    
    NSString * score = [_score generateScoreString];
    CGSize mainSize = [[CCDirector sharedDirector] winSize];
    
    bool didWin = ([_score getScore] >= [_highScore getScore]);
    
    _gameOverLayer = [GameOverLayer initWithScoreString:score
                                                winSize:mainSize
                                                    gameLayer:self
                                                    highScore:didWin];

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

// -----------------------------------------------------------------------------------
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.player changeDirection];
}

@end
