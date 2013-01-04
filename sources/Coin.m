//
//  Coin.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "Coin.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
@implementation Coin
@synthesize emitter=emitter_;
// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Coin is falling
    // from the top of the screen
    [self moveBy:ccp(0, self.gameObjectSpeed)];
    
    if ([self encounterWithPlayer])
    {
//        id actionBy = [CCMoveBy actionWithDuration:1  position: ccp(0,10)];
/*        id FadeAction = [CCFadeOut actionWithDuration:1];
        id callHandler = [CCCallFunc actionWithTarget:self selector:@selector(handleCollision)];
        [self.gameObjectSprite runAction:[CCSequence actions:FadeAction,callHandler, nil]];*/
        //[self.gameObjectSprite runAction:FadeAction];
        [self handleCollision];
    }
    else
    {
        [self recycleOffScreenObjWithUsedPool:self.parentGameLayer.coinUsedPool
                                     freePool:self.parentGameLayer.coinFreePool];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
//    id FadeAction = [CCFadeOut actionWithDuration:1];
//    id callHandler = [CCCallFunc actionWithTarget:self selector:@selector(handleCollision)];
//    [self.gameObjectSprite runAction:[CCSequence actions:FadeAction, nil]];
    self.emitter = [CCParticleSystemQuad particleWithFile:@"ExplodingRing.plist"];

    self.emitter.sourcePosition = self.gameObjectSprite.position;

	[self.parentGameLayer addChild:emitter_ z:10];
    
    [self recycleObjectWithUsedPool:self.parentGameLayer.coinUsedPool
                           freePool:self.parentGameLayer.coinFreePool];
    // increment score
    [self.parentGameLayer.score incrementScore:1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"coin-pick-up.wav"]; 
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}

@end
