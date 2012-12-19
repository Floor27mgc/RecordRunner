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
#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer
@synthesize player = _player;

@synthesize score = _score;

@synthesize background;

@synthesize bombFreePool = _bombFreePool;
@synthesize bombUsedPool = _bombUsedPool;

@synthesize coinFreePool = _coinFreePool;
@synthesize coinUsedPool = _coinUsedPool;

@synthesize gameObjectInjector;
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
        background = [CCSprite spriteWithFile:@"background_small.png"];
        background.anchorPoint=ccp(0,0);
                
        // Create player
        _player = [GameObjectPlayer initWithGameLayer:self
                                        imageFileName:@"player.png"
                                          objectSpeed:0];
        _player.gameObjectSprite.anchorPoint = ccp(0,0);
        [_player moveTo:PLAYER_START_POSITION];

//        [self addChild:background];
        [self addChild:_player.playerStreak];
        [self addChild:_player.gameObjectSprite];
        
        // Create bomb free pool (queue)
        _bombFreePool = [Queue initWithSize:MAX_NUM_BOMBS];
        
        // Create bomb used pool (queue)
        _bombUsedPool = [Queue initWithSize:MAX_NUM_BOMBS];
       
        // Create NUM_OBSTACLES bombs and add them to the free pool
        for (int i = 0; i < MAX_NUM_BOMBS; ++i) {
            Bomb * _bomb = [Bomb initWithGameLayer: self
                              imageFileName:@"Bomb.png"
                                objectSpeed:kDefaultGameObjectSpeed];
            _bomb.gameObjectSprite.visible = 0;
            [_bombFreePool addObject:_bomb];
            
            // add bomb to GameLayer
            [self addChild: _bomb.gameObjectSprite];
        }
        
        // Create coin free pool (queue)
        _coinFreePool = [Queue initWithSize:MAX_NUM_COINS];
        
        // Create coin used pool (queue)
        _coinUsedPool = [Queue initWithSize:MAX_NUM_COINS];
        
        // Create NUM_REWARDS coins and add them to the free pool
        for (int i = 0; i < MAX_NUM_COINS; ++i) {
            Coin * _coin = [Coin initWithGameLayer:self
                              imageFileName:@"Coin.png"
                                objectSpeed:kDefaultGameObjectSpeed];
            _coin.gameObjectSprite.visible = 0;
            [_coinFreePool addObject:_coin];
            
            // add coin to GameLayer
            [self addChild: _coin.gameObjectSprite];
        }
        
        // Create score
        _score = [Score initWithGameLayer:self
                            imageFileName:@""
                              objectSpeed:0];
        [self addChild:_score.score];
        
        // Create Game Object injector to inject Bomb, coins, etc
        gameObjectInjector = [GameObjectInjector initWithGameLayer:self];        

    }

    [self schedule: @selector(update:)];
	return self;
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
- (void) generateGameObject:(game_object_t) type
{
    GameObjectBase * newObject = nil;
    
    // generate x location for new object
    CGSize size = [[CCDirector sharedDirector] winSize];
    int random_x = arc4random() % (int)size.width;
    
    switch (type) {
        case BOMB_TYPE:
            if ([_bombUsedPool.objects count] < MAX_NUM_BOMBS) {
                newObject = [_bombFreePool takeObject];
                if (newObject != nil) {
                    [newObject moveTo:ccp(random_x, 0)];
                    newObject.gameObjectSprite.visible = 1;
                    [_bombUsedPool addObject:newObject];
                }
            }
            break;
        case COIN_TYPE:
            if ([_coinUsedPool.objects count] < MAX_NUM_COINS) {
                newObject = [_coinFreePool takeObject];
                if (newObject != nil) {
                    [newObject moveTo:ccp(random_x, 0)];
                    newObject.gameObjectSprite.visible = 1;
                    [_coinUsedPool addObject:newObject];
                }
            }
            break;
        default:
            break;
    }
}

// -----------------------------------------------------------------------------------
- (void) update:(ccTime) dt
{
//    NSLog(@"%f",dt);
    [_player showNextFrame];
    
    // generate Game Objectsrandomly

    if (arc4random() % RANDOM_MAX == 1) {
        
        [gameObjectInjector injectObjectWithPattern:(arc4random() % patternNumPattern())
                                   initialXPosition:CGPointMake((arc4random() % 160), 0)];
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
    for (int i = 0; i < [_bombUsedPool.objects count]; ++i) {
        [_bombUsedPool.objects[i] showNextFrame];
    }
    
    for (int i = 0; i < [_coinUsedPool.objects count]; ++i) {
        [_coinUsedPool.objects[i] showNextFrame];
    }

    [_score showNextFrame];
}

// -----------------------------------------------------------------------------------
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.player changeDirection];
}

@end
