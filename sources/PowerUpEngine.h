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

- (IS_AVAIL_REASON) IsAvaiable: (PowerUpType) type;
- (BOOL) Purchase: (PowerUpType) type;
- (BOOL) unPurchase:(PowerUpType)type;
- (void) ResetPowerUps;
- (void) setAllPowerUpUnchoosen;

@property (nonatomic, strong) NSMutableArray * PowerUps;

@end
