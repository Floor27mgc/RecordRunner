//
//  SoundController.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/26/13.
//
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "GameObjectBase.h"
@interface SoundController : NSObject

// seconds between bounce pool refreshes
#define BOUNCE_REFRESH_THRESHOLD 5

//---------------------------------
// Different type of sound for
// each game object type
//---------------------------------
#define SOUND_CONTAINER_IDX_COIN 0
#define SOUND_CONTAINER_IDX_BOMB 1
#define SOUND_CONTAINER_IDX_PLAYER 2
#define SOUND_CONTAINER_IDX_MENU 3 


//---------------------------
// Sound file indexes
// to address sound file name
// for each game object type
//---------------------------
// --- Coin ----
#define SOUND_FILENAME_TRK_0_COIN_POPUP 0
#define SOUND_FILENAME_TRK_1_COIN_POPUP 1
#define SOUND_FILENAME_TRK_2_COIN_POPUP 2
#define SOUND_FILENAME_TRK_3_COIN_POPUP 3
#define SOUND_FILENAME_TRK_4_COIN_POPUP 4
#define SOUND_FILENAME_TRK_5_COIN_POPUP 5
#define SOUND_TRK_0_COIN_PICKUP 6
#define SOUND_TRK_1_COIN_PICKUP 7
#define SOUND_TRK_2_COIN_PICKUP 8
#define SOUND_TRK_3_COIN_PICKUP 9
#define SOUND_TRK_4_COIN_PICKUP 10
#define SOUND_MULTI_COIN_PICKUP 11
// --- Bomb ----
#define SOUND_BOMB_POPUP  0
#define SOUND_BOMB_PICKUP 1
#define SOUND_BOMB_SKIM 2
#define SOUND_BOMB_SKIM2 3
// --- PLAYER ---
#define SOUND_PLAYER_SWIPE 0
#define SOUND_PLAYER_DIE 1
#define SOUND_PLAYER_START 2
// --- MENUS ----
#define SOUND_MENU_OPEN 0
#define SOUND_MENU_CLOSE 1
#define SOUND_MENU_CLICK 2

+(id) init;
-(id) init;
-(double) updateMeterSamples;
-(void) soundBounceGameObject:(GameObjectBase *) gameObject
                     withLevel:(double) soundLevel;
+ (SoundController *) sharedSoundController;
-(void) playSoundIdx:(int) soundIdx fromObject:(id) senderObject;

@property (nonatomic, strong) NSString * currentSongTitle;
@property (nonatomic, strong) SimpleAudioEngine * audioEngine;
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
@property (nonatomic, assign) int subsetIdx;
@property (nonatomic, assign) int previousSubset;
@property (nonatomic, assign) int subsetCurrentRepeatCount;
@property (nonatomic, assign) int subsetMaxRepeatCount;
@property (nonatomic, strong) NSArray *soundFileNameContainer;
@end