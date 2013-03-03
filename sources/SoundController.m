//
//  SoundController.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/26/13.
//
//

#import "SoundController.h"
#import "GameObjectBase.h"

@implementation SoundController
@synthesize currentSongTitle;
@synthesize audioEngine;
@synthesize audioPlayer;
@synthesize subsetIdx;
@synthesize subsetCurrentRepeatCount;
@synthesize subsetMaxRepeatCount;
@synthesize previousSubset;

// -----------------------------------------------------------------------------------
+(id) init
{
    SoundController * objCreated = [[self alloc] init];
    objCreated.currentSongTitle = @"JewelBeat - Follow The Beat.wav";
    objCreated.audioEngine = [SimpleAudioEngine sharedEngine];
    [objCreated.audioEngine playBackgroundMusic:objCreated.currentSongTitle];

    objCreated.audioPlayer = [CDAudioManager sharedManager].backgroundMusic.audioSourcePlayer;
    objCreated.audioPlayer.meteringEnabled = YES;
    objCreated.subsetIdx = 1;
    objCreated.previousSubset = 0;
    objCreated.subsetCurrentRepeatCount = 0;
    objCreated.subsetMaxRepeatCount = arc4random() % 10 + 1;
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



