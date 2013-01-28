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

// -----------------------------------------------------------------------------------
- (id) initWithType:(power_type_t)type gameLayer:(GameLayer *)parentLayer
{
    if (self = [super init]) {
        self.powerType = type;
        self.parentGameLayer = parentLayer;
        self.myTrackNum = arc4random() % MAX_NUM_TRACK;
    }
    
    return self;
}

// -----------------------------------------------------------------------------------
- (void) addPower
{
    
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    
}

@end
