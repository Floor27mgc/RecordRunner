//
//  Power.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import "Power.h"

@implementation Power

@synthesize powerType;
@synthesize parentGameLayer;
@synthesize myTrackNum;

// ----------------------------------------------------------------------------------
- (id) initWithType:(power_type_t)type gameLayer:(GameLayer *)parentLayer
{
    if (self = [super init]) {
        self.powerType = type;
        //[GameLayer sharedGameLayer] = parentLayer;
        self.myTrackNum = arc4random() % MAX_NUM_TRACK;
    }
    
    return self;
}

// -----------------------------------------------------------------------------------
- (void) addPower
{
    self.myTrackNum = arc4random() % 4;
    [[GameLayer sharedGameLayer].powerPool addObject:self toTrack:self.myTrackNum];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    
}

// -----------------------------------------------------------------------------------
- (void) resetPower
{
    [[GameLayer sharedGameLayer].powerPool removeObjectFromTrack:self.myTrackNum
                                               withObject:self];
}

@end
