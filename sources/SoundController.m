//
//  SoundController.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/26/13.
//
//

#import "SoundController.h"

@implementation SoundController
@synthesize currentSongTitle;
@synthesize audioEngine;
@synthesize audioPlayer;
@synthesize lastBounceRefresh;

// -----------------------------------------------------------------------------------
+(id) init
{
    SoundController * objCreated = [[self alloc] init];
    objCreated.currentSongTitle = @"JewelBeat - Follow The Beat.wav";
    objCreated.audioEngine = [SimpleAudioEngine sharedEngine];
    [objCreated.audioEngine playBackgroundMusic:objCreated.currentSongTitle];

    objCreated.audioPlayer = [CDAudioManager sharedManager].backgroundMusic.audioSourcePlayer;
    objCreated.audioPlayer.meteringEnabled = YES;
    objCreated.lastBounceRefresh = [NSDate date];

    return objCreated;
}

// -----------------------------------------------------------------------------------
-(id) init
{
        if (self = [super init]) {
        }
        return self;
}

// -----------------------------------------------------------------------------------
-(BOOL) updateMeterSamples
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

    if (filteredAverage_[audioPlayer.numberOfChannels - 1] > .125) {
        return YES;
    } else {
        return NO;
    }
}

// -----------------------------------------------------------------------------------
-(BOOL) refreshBouncePool
{
    NSTimeInterval elapsed = abs([lastBounceRefresh timeIntervalSinceNow]);
    
    if (elapsed > BOUNCE_REFRESH_THRESHOLD) {
        lastBounceRefresh = [NSDate date];
        return YES;
    } else {
        return NO;
    }
}

@end



