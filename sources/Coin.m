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
#import "SoundController.h"

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
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_RECORD_CENTER,self.radius,self.angleRotated)];
    self.angleRotated = self.angleRotated + self.gameObjectAngularVelocity;
    [self encounterWithPlayer];
    
/*    if ([self encounterWithPlayer])
    {
        [self handleCollision];
    }
    else
    {
//        [self recycleOffScreenObjWithUsedPool:[GameLayer sharedGameLayer].coinUsedPool
//                                     freePool:[GameLayer sharedGameLayer].coinFreePool];
    }*/
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
    [GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife++;
    [[GameLayer sharedGameLayer].score incrementScore:
        [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch];

    //increment coins this scratch if you have started the scratch
    if ([GameLayer sharedGameLayer].player.playerRadialSpeed > 0)
    {
        [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch++;
    }    

    int soundIdxToPlay;
    switch (TRACKNUM_FROM_RADIUS)
    {
        case 0: soundIdxToPlay = SOUND_TRK_0_COIN_PICKUP;
            break;
        case 1: soundIdxToPlay = SOUND_TRK_1_COIN_PICKUP;
            break;
        case 2: soundIdxToPlay = SOUND_TRK_2_COIN_PICKUP;
            break;
        case 3: soundIdxToPlay = SOUND_TRK_3_COIN_PICKUP;
            break;
        default:
            soundIdxToPlay = SOUND_TRK_0_COIN_PICKUP;
            break;
    }
    
    [[SoundController sharedSoundController] playSoundIdx:soundIdxToPlay fromObject:self];
    
    //Play a sound if collect more than one coin in a pass
    if ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch >= 3)
    {
        [[SoundController sharedSoundController] playSoundIdx:SOUND_MULTI_COIN_PICKUP fromObject:self];
    }
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
