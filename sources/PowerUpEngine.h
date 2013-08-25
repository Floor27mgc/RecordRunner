//
//  PowerUpEngine.h
//  Rotato
//
//  Created by Matt Cleveland on 8/25/13.
//
//

#import <Foundation/Foundation.h>
#import "PowerUp.h"

@interface PowerUpEngine : NSObject

- (BOOL) IsAvaiable: (PowerUpType) type;
- (BOOL) Purchase: (PowerUpType) type;
- (void) ResetPowerUps;

@property (nonatomic, strong) NSMutableArray * PowerUps;

@end
