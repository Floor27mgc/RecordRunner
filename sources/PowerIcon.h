//
//  PowerIcon.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import "GameObjectBase.h"
#import "Power.h"
#import "PowerFireMissle.h"
#import "PowerSlowDown.h"
#import "PowerShield.h"

@interface PowerIcon : GameObjectBase

+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed
               powerType:(power_type_t) pType;

// static method -- return filename for supplied power type
+ (NSString *) getIconImageFromPowerType:(power_type_t) pType;

@property (nonatomic) power_type_t type;

@end
