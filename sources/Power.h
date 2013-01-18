//
//  Power.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import <Foundation/Foundation.h>
#include "GameLayer.h"

typedef enum {
    slow_down,
    fire_missle
} power_type_t;

@interface Power : NSObject

- (id) initWithType:(power_type_t) type
    gameLayer:(GameLayer *) parentLayer;

// add this power's effect to the main game layer
- (void) addPower;

// trigger the start of this power in the main game layer
- (void) runPower;

@property (nonatomic) power_type_t powerType;
@property (nonatomic, assign) GameLayer * parentGameLayer;

@end
