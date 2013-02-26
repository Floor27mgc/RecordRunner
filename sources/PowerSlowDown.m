//
//  PowerSlowDown.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/27/13.
//
//

#import "PowerSlowDown.h"

@implementation PowerSlowDown
/*
@synthesize startTime = _startTime;
@synthesize mySpeed = _mySpeed;
@synthesize didISlowDown = _didISlowDown;

static BOOL slowedDown = NO;

// ----------------------------------------------------------------------------------
+(BOOL) slowDownActive
{
    return slowedDown;
}

// ----------------------------------------------------------------------------------
+(void) setSlowDownActive:(BOOL) newVal
{
    slowedDown = newVal;
}

// ----------------------------------------------------------------------------------
- (void) addPower
{
    _startTime = [NSDate date];
    
    _mySpeed = (arc4random() % 5) + 1;
    
    _didISlowDown = YES;
    
    [super addPower];
    
    [self slowDown];
 }

// ----------------------------------------------------------------------------------
- (void) slowDown
{
    if (![PowerSlowDown slowDownActive]) {
        [PowerSlowDown setSlowDownActive: YES];
        
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.bombUsedPool
                                       up:NO speed:_mySpeed];
    
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.bombFreePool
                                       up:NO speed:_mySpeed];

        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.coinUsedPool
                                       up:NO speed:_mySpeed];

        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.coinFreePool
                                       up:NO speed:_mySpeed];
    
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.powerIconUsedPool
                                       up:NO speed:_mySpeed];
        
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.powerIconFreePool
                                       up:NO speed:_mySpeed];
    } else {
        _didISlowDown = NO;
    }
}

// ----------------------------------------------------------------------------------
- (void) speedUp
{
    if (_didISlowDown) {
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.bombUsedPool
                                       up:YES speed:_mySpeed];
    
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.bombFreePool
                                       up:YES speed:_mySpeed];
    
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.coinUsedPool
                                       up:YES speed:_mySpeed];
    
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.coinFreePool
                                       up:YES speed:_mySpeed];
    
        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.powerIconUsedPool
                                       up:YES speed:_mySpeed];

        [self.parentGameLayer changeGameObjectsSpeed:self.parentGameLayer.powerIconFreePool
                                       up:YES speed:_mySpeed];
        [PowerSlowDown setSlowDownActive: NO];
    }
}

// ----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    
    if (elapsed > SLOW_DOWN_LIFETIME_SEC) {
        [self speedUp];
        [super resetPower];
    } else {
    }
}
*/
// ----------------------------------------------------------------------------------
/*- (void) changeGameLayerObjectsSpeed:(Queue *)pool up:(BOOL)speedUp speed:(int)factor
{
    if (factor <= 0) {
        return;
    }
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        for (int i = 0; i < POOL_OBJ_COUNT_ON_TRACK(pool, trackNum); ++i) {
            GameObjectBase * tempObj = POOL_OBJS_ON_TRACK(pool, trackNum)[i];
            
            if (speedUp) {
                tempObj.gameObjectAngularVelocity++;
            } else {
                tempObj.gameObjectAngularVelocity--;
                
                if (tempObj.gameObjectAngularVelocity == 0) {
                    tempObj.gameObjectAngularVelocity = 1;
                }
            }
        }
    }
}*/

@end
