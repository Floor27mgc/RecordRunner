//
//  PowerSlowDown.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/27/13.
//
//

#import "PowerSlowDown.h"

@implementation PowerSlowDown

@synthesize startTime = _startTime;
@synthesize mySpeed = _mySpeed;

// ----------------------------------------------------------------------------------
- (void) addPower
{
    _startTime = [NSDate date];
    
    _mySpeed = (arc4random() % 5) + 1;
 
    [super addPower];
    
    [self slowDown];
 }

// ----------------------------------------------------------------------------------
- (void) slowDown
{
    [self changeGameLayerObjectsSpeed:self.parentGameLayer.bombUsedPool
                                   up:NO speed:_mySpeed];

    [self changeGameLayerObjectsSpeed:self.parentGameLayer.coinUsedPool
                                   up:NO speed:_mySpeed];

    [self changeGameLayerObjectsSpeed:self.parentGameLayer.powerIconPool
                                   up:NO speed:_mySpeed];
}

// ----------------------------------------------------------------------------------
- (void) speedUp
{
    [self changeGameLayerObjectsSpeed:self.parentGameLayer.bombUsedPool
                                   up:YES speed:_mySpeed];
    
    [self changeGameLayerObjectsSpeed:self.parentGameLayer.coinUsedPool
                                   up:YES speed:_mySpeed];
    
    [self changeGameLayerObjectsSpeed:self.parentGameLayer.powerIconPool
                                   up:YES speed:_mySpeed];
}

// ----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    
    if (elapsed > SLOW_DOWN_LIFETIME_SEC) {
        NSLog(@"Slow down complete...");
        [self speedUp];
        [super resetPower];
    } else {
        NSLog(@"Still slowing down, %f elapsed...", elapsed);
    }
}

// ----------------------------------------------------------------------------------
- (void) changeGameLayerObjectsSpeed:(Queue *)pool up:(BOOL)speedUp speed:(int)factor
{
    if (factor <= 0) {
        return;
    }
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(pool, trackNum); ++i) {
            GameObjectBase * tempObj = POOL_OBJS_ON_TRACK(pool, trackNum)[i];
            
            if (speedUp) {
                tempObj.gameObjectAngularVelocity *= factor;
            } else {
                tempObj.gameObjectAngularVelocity /= factor;
            }
        }
    }
}

@end
