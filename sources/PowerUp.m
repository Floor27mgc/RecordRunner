//
//  PowerUp.m
//  Rotato
//
//  Created by Matt Cleveland on 8/25/13.
//
//

#import "PowerUp.h"
#import "GameInfoGlobal.h"

@implementation PowerUp

@synthesize cost;
@synthesize type;

// ----------------------------------------------------------------------------------
- (id) initWithType:(PowerUpType)pType
{
    if (self = [super init]) {
        self.type = pType;
        
        switch (self.type) {
            case BLANK_SPACE:
                self.cost = PRICE_BLANK_SPACE;
                break;
            case RECORD_SPINS_SLOWER:
                self.cost = PRICE_RECORD_SPINS_SLOWER;
                break;
            case INCREASE_STAR_SPAWN_RATE:
                self.cost = PRICE_INCREASE_STAR_SPAWN_RATE;
                break;
            case CLOSE_CALL_TIMES_2:
                self.cost = PRICE_CLOSE_CALL_TIMES_2;
                break;
            case MINIMUM_MULTIPLIER_OF_3:
                self.cost = PRICE_MINIMUM_MULTIPLIER_OF_3;
                break;
            case START_WITH_SHIELD:
                self.cost = PRICE_START_WITH_SHIELD;
                break;
            case DOUBLE_COINS:
                self.cost = PRICE_DOUBLE_COINS;
                break;
            default:
                break;
        }
    }
    
    return self;
}

// ----------------------------------------------------------------------------------
// withdraw the coins for this power up from the coin bank and apply the power up
// changes to the game state
- (BOOL) Purchase
{
    if ([self Available]) {
        
        [[GameInfoGlobal sharedGameInfoGlobal] WithdrawCoinsFromBank:cost];
        
        switch (type) {
            case RECORD_SPINS_SLOWER:
                [GameInfoGlobal sharedGameInfoGlobal].changeGameVelocity = -0.2;
                break;
                
            case INCREASE_STAR_SPAWN_RATE:
                [GameInfoGlobal sharedGameInfoGlobal].increasedStarSpawnRate = YES;
                break;
                
            case CLOSE_CALL_TIMES_2:
                [GameInfoGlobal sharedGameInfoGlobal].closeCallMultiplier = 2;
                break;
                
            case MINIMUM_MULTIPLIER_OF_3:
                [GameInfoGlobal sharedGameInfoGlobal].minMultVal = 3;
                break;
                
            case START_WITH_SHIELD:
                [GameInfoGlobal sharedGameInfoGlobal].playerStartsWithShield = YES;
                break;
                
            case DOUBLE_COINS:
                [GameInfoGlobal sharedGameInfoGlobal].coinValue = 2;
                break;
                
            default:
                break;
        }
        
    } else {
        return NO;
    }
    
    return YES;
}


// ----------------------------------------------------------------------------------
// undo what you purchased. This occurs when you click the circle at the top to un-purchase it.
- (BOOL) UnPurchase
{
    if ([self Available]) {
        
        [[GameInfoGlobal sharedGameInfoGlobal] AddCoinsToBank:cost];
        
        [self Reset];
        
    } else {
        return NO;
    }
    
    return YES;
}


// ----------------------------------------------------------------------------------
// determine if there are enough coins to purchase this power up
- (BOOL) Available
{
    return YES;
    return ([GameInfoGlobal sharedGameInfoGlobal].coinsInBank > cost);
}

// ----------------------------------------------------------------------------------
// revert the game state to the non-power up state
- (void) Reset
{
    switch (type) {
        case RECORD_SPINS_SLOWER:
            [GameInfoGlobal sharedGameInfoGlobal].changeGameVelocity = 0.0;
            break;
            
        case INCREASE_STAR_SPAWN_RATE:
            [GameInfoGlobal sharedGameInfoGlobal].increasedStarSpawnRate = NO;
            break;
            
        case CLOSE_CALL_TIMES_2:
            [GameInfoGlobal sharedGameInfoGlobal].closeCallMultiplier = 1;
            break;
            
        case MINIMUM_MULTIPLIER_OF_3:
            [GameInfoGlobal sharedGameInfoGlobal].minMultVal = 1;
            break;
            
        case START_WITH_SHIELD:
            [GameInfoGlobal sharedGameInfoGlobal].playerStartsWithShield = NO;
            break;
            
        case DOUBLE_COINS:
            [GameInfoGlobal sharedGameInfoGlobal].coinValue = 1;
            break;
            
        default:
            break;
    }
}

@end
