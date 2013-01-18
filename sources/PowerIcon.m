//
//  PowerIcon.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import "PowerIcon.h"

@implementation PowerIcon

@synthesize type;

// -----------------------------------------------------------------------------------
+ (id) initWithGameLayer:(GameLayer *)gamelayer
           imageFileName:(NSString *)fileName
             objectSpeed:(int)speed
               powerType:(power_type_t)pType
{
    PowerIcon * objCreated = [self initWithGameLayer:gamelayer
                                    imageFileName:fileName
                                        objectSpeed:speed];
    objCreated.type = pType;
    
    return objCreated;
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Coin is falling
    // from the top of the screen
    [self moveBy:ccp(0, self.gameObjectSpeed)];
    
    if ([self encounterWithPlayer]) {
        [self handleCollision];
    } else {
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        CGPoint curPoint = [self.gameObjectSprite position];
        
        if (curPoint.y > windowSize.height) {
            NSLog(@"removing icon from pool, size is %i",
                  [self.parentGameLayer.powerIconPool.objects count]);
            [self removeFromGamePool:self.parentGameLayer.powerIconPool];
            NSLog(@"icon removed from pool, size is %i",
                  [self.parentGameLayer.powerIconPool.objects count]);
        }
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    Power * newPower;

    // instantiate new Power object
    switch (type) {
        case fire_missle:
            NSLog(@"Creating a missle PowerUp");
            newPower = [[PowerFireMissle alloc] initWithType:fire_missle
                                                   gameLayer:self.parentGameLayer];
            break;
        case slow_down:
            NSLog(@"Slow down type");
            break;
        default:
            break;
    }
    
    // remove PowerIcon from the parent game layer
    [self removeFromGamePool:self.parentGameLayer.powerIconPool];
    
    // add Power object to parentGameLayer
    [newPower addPower];
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}

@end
