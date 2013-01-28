//
//  PowerFireMissle.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import "Power.h"
#import "GameObjectBase.h"
#import "Missile.h"
#import "GameObjectInjector.h"

@interface PowerFireMissle : Power

- (void) resetObject;

@property (nonatomic, strong) Missile * missle;

@end
