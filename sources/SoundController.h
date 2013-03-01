//
//  SoundController.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/26/13.
//
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface SoundController : NSObject

// seconds between bounce pool refreshes
#define BOUNCE_REFRESH_THRESHOLD 5

+(id) init;
-(id) init;
-(BOOL) updateMeterSamples;
-(BOOL) refreshBouncePool;

@property (nonatomic, strong) NSString * currentSongTitle;
@property (nonatomic, strong) SimpleAudioEngine * audioEngine;
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
@property (nonatomic, strong) NSDate * lastBounceRefresh;

@end