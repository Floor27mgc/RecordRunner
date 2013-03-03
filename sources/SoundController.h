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

+(id) init;
-(id) init;
-(double) updateMeterSamples;
-(void) soundBounceGameObject:(GameObjectBase *) gameObject
                     withLevel:(double) soundLevel;

@property (nonatomic, strong) NSString * currentSongTitle;
@property (nonatomic, strong) SimpleAudioEngine * audioEngine;
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
@property (nonatomic, assign) int subsetIdx;
@property (nonatomic, assign) int previousSubset;
@property (nonatomic, assign) int subsetCurrentRepeatCount;
@property (nonatomic, assign) int subsetMaxRepeatCount;
@end