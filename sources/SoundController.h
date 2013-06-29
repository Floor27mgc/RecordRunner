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

//---------------------------
// Sound file indexes
// to address sound file name
// for each game object type
//---------------------------
// --- Coin ----
#define SOUND_FILENAME_IDX_COIN_POPUP  0
#define SOUND_FILENAME_IDX_COIN_PICKUP 1
// --- Bomb ----
#define SOUND_FILENAME_IDX_BOMB_POPUP  0
#define SOUND_FILENAME_IDX_BOMB_PICKUP 1

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