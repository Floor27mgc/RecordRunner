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
@synthesize isDead = _isDead;

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        _bouncing = NO;
        _isDead = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}


// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Coin is falling
    // from the top of the screen
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_RECORD_CENTER,self.radius,self.angleRotated)];
    self.angleRotated = self.angleRotated + self.gameObjectAngularVelocity;
    [self encounterWithPlayer];
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:COIN_STATS] tick];
    
    if (!_isDead)
    {
        if ([GameLayer sharedGameLayer].isDebugMode == YES)
            return;
        
        _isDead = YES;
        
        NSString *scoreText = @"";
        
        // increment coins this scratch if you have started the scratch
        // and update max accordingly
        [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch++;
        if ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch >
            [GameInfoGlobal sharedGameInfoGlobal].maxCoinsPerScratch) {

            [GameInfoGlobal sharedGameInfoGlobal].maxCoinsPerScratch =
                [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch;
        }

        // if we aren't moving then coinsThisScratch is zero, we should still register
        // this coin as 1
        int coinsToCount = ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch == 0 ?
                            1 : [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch);
        
        //This is the pre-multiplier count of the coins. This goes off a fibinacci sequence
        //1 coin = 1
        //2 coins = 2+1
        //3 coins = 4 + 2 + 1
        //4 coins = 8 + 4 + 2 + 1 
        int fibNumber = 1;
        display_effect scoreSize = small;
                
        
        
        //Show the different colored explosions depending on howmany collected in one chain.
        switch (coinsToCount)
        {
            case 0:
            case 1:
                
                [self.animationManager runAnimationsForSequenceNamed:@"Die1"];
                
                scoreText = [NSString stringWithFormat:@""];
                break;
            case 2:
                [self.animationManager runAnimationsForSequenceNamed:@"Die2"];
                
                fibNumber = 2;
                scoreText = [NSString stringWithFormat:@"%d", fibNumber * [GameLayer sharedGameLayer].multiplier.multiplierValue ];
                break;
            case 3:
                [self.animationManager runAnimationsForSequenceNamed:@"Die3"];
                
                
                fibNumber = 4;
                scoreText = [NSString stringWithFormat:@"%d", fibNumber * [GameLayer sharedGameLayer].multiplier.multiplierValue];
                scoreSize = large;
                break;
            case 4:
                [self.animationManager runAnimationsForSequenceNamed:@"Die4"];
                
                fibNumber = 8;
                scoreText = [NSString stringWithFormat:@"%d", fibNumber * [GameLayer sharedGameLayer].multiplier.multiplierValue];
                scoreSize = large;
                break;
            default:
                [self.animationManager runAnimationsForSequenceNamed:@"Die1"];
                
                fibNumber = 1;
                scoreText = [NSString stringWithFormat:@"1"];
                break;
        }
        
        // increment score
        [GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife++;
        [[GameLayer sharedGameLayer].score incrementScore: fibNumber]; //Send them the fibinacci number
        
        //Show those ghost score text above the bomb.
        [[GameLayer sharedGameLayer] showScoreOnTrack:TRACKNUM_FROM_RADIUS message: scoreText displayEffect:scoreSize];
        
        //Only play the sound if the player is NOT invincible
        if (![[GameLayer sharedGameLayer].player hasShield])
        {
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
            if ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch >= 2)
            {
                [[SoundController sharedSoundController] playSoundIdx:SOUND_MULTI_COIN_PICKUP fromObject:self];
            }
        }
    }
}

// -----------------------------------------------------------------------------------
-(void) bounce
{
    
    [self.animationManager runAnimationsForSequenceNamed:@"QuickBounce"];
}


// -----------------------------------------------------------------------------------
- (void) resetObject
{
    _isDead = NO;
    [super resetObject];
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if (_isDead)
    {
        [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].coinUsedPool                  freePool:[GameLayer sharedGameLayer].coinFreePool];
    }
}

@end
