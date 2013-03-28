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
#import "GameInfoGlobal.h"

@implementation Coin

@synthesize emitter=emitter_;
@synthesize bouncing = _bouncing;

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        _bouncing = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Coin is falling
    // from the top of the screen
    //[self moveBy:ccp(0, self.gameObjectSpeed)];
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,self.radius,self.angleRotated)];
    self.angleRotated = self.angleRotated + self.gameObjectAngularVelocity;
    if ([self encounterWithPlayer])
    {
        [self handleCollision];
    }
    else
    {
//        [self recycleOffScreenObjWithUsedPool:[GameLayer sharedGameLayer].coinUsedPool
//                                     freePool:[GameLayer sharedGameLayer].coinFreePool];
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:COIN_STATS] tick];

    if ([GameLayer sharedGameLayer].isDebugMode == YES)
        return;
    
    [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].coinUsedPool
                           freePool:[GameLayer sharedGameLayer].coinFreePool];
    // increment score
    [[GameLayer sharedGameLayer].score incrementScore:1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"pickup_coin.wav"];
}

// -----------------------------------------------------------------------------------
-(void) bounce
{
    [self.animationManager runAnimationsForSequenceNamed:@"QuickBounce"];
}

// -----------------------------------------------------------------------------------
/*-(void) scaleMe:(double)factor
{
    if (factor < 0) {
        return;
    }
    
    double scaleFactor = factor+1;//1 + (3*factor);
//    NSLog(@"scaling to: %f", scaleFactor);
//    CCSprite * coinImage;
//    NSLog(@"coin position, x: %f y: %f ", coinImage.position.x, coinImage.position.y);
    //self.gameObjectSprite.anchorPoint = ccp( 0.5, 0.5 );
    //id myAction  = [CCScaleTo actionWithDuration:0.01 scale:scaleFactor];
    //[self runAction:[CCSequence actions:myAction, nil]];
    //[self.gameObjectSprite runAction:myAction];
    self.scaleX = scaleFactor;
    self.scaleY = scaleFactor;
}*/

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}

@end
