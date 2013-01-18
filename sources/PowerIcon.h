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

@interface PowerIcon : GameObjectBase

+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed
               powerType:(power_type_t) pType;

- (void) removeMeFromIconPool;

@property (nonatomic) power_type_t type;

@end
