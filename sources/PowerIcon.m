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
    [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER, self.radius,
                                             self.angleRotated)];
    self.angleRotated = self.angleRotated + self.gameObjectAngularVelocity;
    
    if ([self encounterWithPlayer]) {
        [self handleCollision];
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
            NSLog(@"Creating a slow down PowerUp");
            newPower = [[PowerSlowDown alloc] initWithType:slow_down
                                                 gameLayer:self.parentGameLayer];
            break;
        case shield:
            NSLog(@"Creating a shield PowerUp");
            newPower = [[PowerShield alloc] initWithType:shield
                                               gameLayer:self.parentGameLayer];
        default:
            break;
    }
    
    // remove PowerIcon from the parent game layer
    [self recycleObjectWithUsedPool:self.parentGameLayer.powerIconUsedPool
                           freePool:self.parentGameLayer.powerIconFreePool];
    
    // add Power object to parentGameLayer
    [newPower addPower];
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [super resetObject];
}

// -----------------------------------------------------------------------------------
+ (NSString *) getIconImageFromPowerType:(power_type_t) pType
{
    NSString * fileName = nil;
    
    switch (pType) {
        case fire_missle:
            fileName = @"missle_icon.png";
            break;
        case slow_down:
            fileName = @"clock.png";
            break;
        case shield:
            fileName = @"shield.jpg";
            break;
        default:
            break;
    }
    
    return fileName;
}

@end
