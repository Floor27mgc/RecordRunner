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

// -----------------------------------------------------------------------------------
- (id) initWithType:(power_type_t)type gameLayer:(GameLayer *)parentLayer
{
    if (self = [super init]) {
        self.powerType = type;
        self.parentGameLayer = parentLayer;
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

@end
