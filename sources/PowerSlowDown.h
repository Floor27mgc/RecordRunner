//
//  PowerSlowDown.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/27/13.
//
//

#import "Power.h"

#define SLOW_DOWN_LIFETIME_SEC 7

@interface PowerSlowDown : Power

// static methods to ensure slow downs don't "stack"
+ (BOOL) slowDownActive;
+ (void) setSlowDownActive:(BOOL) newVal;

// change speed of objects from parent game layer pools
- (void) changeGameLayerObjectsSpeed:(Queue *) pool
                                  up:(BOOL) speedUp
                                    speed:(int) factor;

// slow down objects on parent game layer pools
- (void) slowDown;

// speed up objects on parent game layer pools
- (void) speedUp;

@property (nonatomic) NSDate * startTime;
@property (nonatomic) int mySpeed;
@property (nonatomic) BOOL didISlowDown;

@end
