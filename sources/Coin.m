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
        
        //increment coins this scratch if you have started the scratch
        if ([GameLayer sharedGameLayer].player.playerRadialSpeed > 0)
        {
            [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch++;
        }
        
        // if we aren't moving then coinsThisScratch is zero, we should still register
        // this coin as 1
        int coinsToCount = ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch == 0 ?
                            1 : [GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch);
                
        // increment score
        [GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife++;
        [[GameLayer sharedGameLayer].score incrementScore: coinsToCount];
        
        //Show the different colored explosions depending on howmany collected in one chain.
        switch ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch)
        {
            case 0:
                [self.animationManager runAnimationsForSequenceNamed:@"Die1"];
                
                /*
                scoreText = [NSString stringWithFormat:@"%d", (1 * [GameLayer sharedGameLayer].multiplier.getMultiplier)];
                */
                
                scoreText = [NSString stringWithFormat:@"1"];
                break;
            case 1:                
                [self.animationManager runAnimationsForSequenceNamed:@"Die2"];
                
                scoreText = [NSString stringWithFormat:@"2"];
                break;
            case 2:
                [self.animationManager runAnimationsForSequenceNamed:@"Die3"];
                
                scoreText = [NSString stringWithFormat:@"3"];
                break;
            case 3:
                [self.animationManager runAnimationsForSequenceNamed:@"Die4"];
                
                scoreText = [NSString stringWithFormat:@"4"];
                break;
            case 4:
                [self.animationManager runAnimationsForSequenceNamed:@"Die5"];
                
                scoreText = [NSString stringWithFormat:@"5"];
                break;
            default:
                [self.animationManager runAnimationsForSequenceNamed:@"Die1"];
                
                scoreText = [NSString stringWithFormat:@"1"];
                break;
        }
        
        //Show those ghost score text above the bomb.
        [[GameLayer sharedGameLayer] showScoreOnTrack:TRACKNUM_FROM_RADIUS message: scoreText];
        
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
