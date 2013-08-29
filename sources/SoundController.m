//
//  SoundController.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/26/13.
//
//

#import "SoundController.h"
#import "GameObjectBase.h"
#import "Coin.h"
#import "Bomb.h"
#import "GameInfoGlobal.h"
#import "MenuBox.h"
#import "GameObjectPlayer.h"
#import "BuyCoinsMenu.h"

@implementation SoundController
@synthesize currentSongTitle;
@synthesize audioEngine;
@synthesize audioPlayer;
@synthesize subsetIdx;
@synthesize subsetCurrentRepeatCount;
@synthesize subsetMaxRepeatCount;
@synthesize previousSubset;
@synthesize soundFileNameContainer;

static SoundController *SoundControllerSingleton;

// -----------------------------------------------------------------------------------
+ (SoundController *) sharedSoundController
{
    return SoundControllerSingleton;
}

// -----------------------------------------------------------------------------------
+(id) init
{
    SoundController * objCreated = [[self alloc] init];
    
    objCreated.currentSongTitle = @"JewelBeat - Follow The Beat.caf";
    objCreated.audioEngine = [SimpleAudioEngine sharedEngine];
    objCreated.audioPlayer = [CDAudioManager sharedManager].backgroundMusic.audioSourcePlayer;
    objCreated.audioPlayer.meteringEnabled = YES;
    objCreated.subsetIdx = 1;
    objCreated.previousSubset = 0;
    objCreated.subsetCurrentRepeatCount = 0;
    objCreated.subsetMaxRepeatCount = arc4random() % 10 + 1;
    SoundControllerSingleton = objCreated;
    
    return objCreated;
}

// -----------------------------------------------------------------------------------
-(id) init
{
    if (self = [super init]) {
        // Fill in filenames into the soundFileContainer
        NSArray *coinSoundFiles = [[NSArray alloc] initWithObjects:
                                   @"popin1.caf",   // SOUND_FILENAME_TRK_0_COIN_POPUP
                                   @"popin2.caf",   // SOUND_FILENAME_TRK_1_COIN_POPUP
                                   @"popin3.caf",   // SOUND_FILENAME_TRK_2_COIN_POPUP
                                   @"popin4.caf",   // SOUND_FILENAME_TRK_3_COIN_POPUP
                                   @"popin5.caf",   // SOUND_FILENAME_TRK_4_COIN_POPUP
                                   @"popin5.caf",   // SOUND_FILENAME_TRK_5_COIN_POPUP
                                   @"hihat1.caf",     // SOUND_TRK_0_COIN_PICKUP
                                   @"hihat2.caf",     // SOUND_TRK_1_COIN_PICKUP
                                   @"hihat3.caf",     // SOUND_TRK_2_COIN_PICKUP
                                   @"hihat4.caf",     // SOUND_TRK_3_COIN_PICKUP
                                   @"hihat5.caf",     // SOUND_TRK_4_COIN_PICKUP
                                   @"hihatmulti.caf", // SOUND_MULTI_COIN_PICKUP
                                   nil];
        NSArray *bombSoundFiles = [[NSArray alloc] initWithObjects:
                                   @"kicker.caf",   // SOUND_FILENAME_IDX_BOMB_POPUP
                                   @"chime.caf",    // SOUND_FILENAME_IDX_BOMB_PICKUP
                                   @"clap.caf",     //SOUND_BOMB_SKIM
                                   @"clap2.caf",    //SOUND_BOMB_SKIM2
                                   @"inv_bomb_pickup.caf",    //SOUND_BOMB_INV_PICKUP
                                   nil];
        
        NSArray *playerSoundFiles = [[NSArray alloc] initWithObjects:
                                     @"swipe.caf", //SOUND_PLAYER_SWIPE
                                     @"scratch_backspin.caf", //SOUND_PLAYER_DIE
                                     @"record_drop.caf", //SOUND_PLAYER_START
                                     @"player_inv_left.caf", //SOUND_PLAYER_INV_LEFT
                                     @"player_inv_right.caf", //SOUND_PLAYER_INV_RIGHT
                                     @"invincible_on.caf", //SOUND_PLAYER_GOT_INV
                                     @"swipe.caf", //SOUND_PLAYER_SCRATCH_LEFT
                                     @"swipe.caf", //SOUND_PLAYER_SCRATCH_RIGHT
                                     nil];
        
        NSArray *menuSoundEffects = [[NSArray alloc] initWithObjects:
                                     @"swipe.caf", //SOUND_MENU_OPEN
                                     @"swipe.caf", //SOUND_MENU_CLOSE
                                     @"swipe.caf", //SOUND_MENU_CLICK
                                     nil];
        NSArray *buyCoinMenuEffect = [[NSArray alloc] initWithObjects:
                                     @"pickup_coin1.caf", // SOUND_MENU_COIN_INCREASE
                                     nil];
        soundFileNameContainer = [[NSArray alloc]initWithObjects:
                                  coinSoundFiles, // SOUND_CONTAINER_IDX_COIN
                                  bombSoundFiles, // SOUND_CONTAINER_IDX_BOMB
                                  playerSoundFiles, //SOUND_CONTAINER_IDX_PLAYER
                                  menuSoundEffects, //SOUND_CONTAINER_IDX_MENU
                                  buyCoinMenuEffect, // SOUND_CONTAINER_IDX_BUY_COIN_MENU
                                  nil];
    }
    return self;
}

// -----------------------------------------------------------------------------------
-(void) playSoundIdx:(int) soundIdx fromObject:(id) senderObject
{
    NSArray *soundFileNames = nil;
    
    if ([senderObject isKindOfClass:[Coin class]]) {
        soundFileNames = [soundFileNameContainer objectAtIndex:SOUND_CONTAINER_IDX_COIN];
    }
    
    if ([senderObject isKindOfClass:[Bomb class]]) {
        soundFileNames = [soundFileNameContainer objectAtIndex:SOUND_CONTAINER_IDX_BOMB];
    }

    if ([senderObject isKindOfClass:[GameObjectPlayer class]]) {
        soundFileNames = [soundFileNameContainer objectAtIndex:SOUND_CONTAINER_IDX_PLAYER];
    }
    
    if ([senderObject isKindOfClass:[MenuBox class]])
    {
        soundFileNames = [soundFileNameContainer objectAtIndex: SOUND_CONTAINER_IDX_MENU];
    }

    if ([senderObject isKindOfClass:[BuyCoinsMenu class]])
    {
        soundFileNames = [soundFileNameContainer objectAtIndex: SOUND_CONTAINER_IDX_BUY_COIN_MENU];
    }
    if ([GameInfoGlobal sharedGameInfoGlobal].isSoundEffectOn)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:soundFileNames[soundIdx]];
    }

}

// -----------------------------------------------------------------------------------
-(double) updateMeterSamples
{
    [audioPlayer updateMeters];
    
    double filterSmooth_ = 0.2f;
    double filteredPeak_[audioPlayer.numberOfChannels];
    double filteredAverage_[audioPlayer.numberOfChannels];
    
    for(ushort i = 0; i < audioPlayer.numberOfChannels; ++i){
        if (i == audioPlayer.numberOfChannels - 1) {
            //	convert the -160 to 0 dB to [0..1] range
            double peakPowerForChannel =
                pow(10, (0.05 * [audioPlayer peakPowerForChannel:i]));
            double avgPowerForChannel =
                pow(10, (0.05 * [audioPlayer averagePowerForChannel:i]));
            
            filteredPeak_[i] = filterSmooth_ * peakPowerForChannel + (1.0 - filterSmooth_) * filteredPeak_[i];
            filteredAverage_[i] = filterSmooth_ * avgPowerForChannel + (1.0 - filterSmooth_) * filteredAverage_[i];
         }
    }

    return (filteredAverage_[audioPlayer.numberOfChannels - 1]*4);

}

// -----------------------------------------------------------------------------------
- (void) soundBounceGameObject:(GameObjectBase *) gameObject
                     withLevel:(double) soundLevel;
{

    // Determine if we need to change subset.
    if (subsetCurrentRepeatCount >= subsetMaxRepeatCount)
    {
        subsetMaxRepeatCount = arc4random() % 10 + 5;
        subsetCurrentRepeatCount = 0;
        previousSubset = subsetIdx;
        subsetIdx = arc4random()%10+1;
        
        if ((previousSubset != 0) && (gameObject.tag % previousSubset == 0))
        {
            [(GameObjectBase *)gameObject scaleMe:0];
        }
    }

    [gameObject scaleMe:((gameObject.tag % subsetIdx == 0)?soundLevel:0)];
}


@end



