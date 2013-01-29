//
//  PowerSlowDown.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/27/13.
//
//

#import "Power.h"

#define SLOW_DOWN_LIFETIME_SEC 10

@interface PowerSlowDown : Power

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

@end
