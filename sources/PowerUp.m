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
@synthesize isChoosen;
// ----------------------------------------------------------------------------------
- (id) initWithType:(PowerUpType)pType
{
    if (self = [super init]) {
        self.type = pType;
        self.isChoosen = NO;
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
    if ([self Available] == IS_AVAIL_OK) {
        
        [[GameInfoGlobal sharedGameInfoGlobal] WithdrawCoinsFromBank:cost];
        self.isChoosen = YES;
        switch (type) {
            case RECORD_SPINS_SLOWER:
                [GameInfoGlobal sharedGameInfoGlobal].changeGameVelocity = -0.2;
                [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                    at:STATS_RECORD_SPINS_SLOWER] tick];
                break;
                
            case INCREASE_STAR_SPAWN_RATE:
                [GameInfoGlobal sharedGameInfoGlobal].increasedStarSpawnRate = YES;
                [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                    at:STATS_INCREASE_STAR_SPAWN_RATE] tick];
                break;
                
            case CLOSE_CALL_TIMES_2:
                [GameInfoGlobal sharedGameInfoGlobal].closeCallMultiplier = 2;
                [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                    at:STATS_CLOSE_CALL_TIMES_2] tick];
                break;
                
            case MINIMUM_MULTIPLIER_OF_3:
                [GameInfoGlobal sharedGameInfoGlobal].minMultVal = 3;
                [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                    at:STATS_MINIMUM_MULTIPLIER_OF_3] tick];
                break;
                
            case START_WITH_SHIELD:
                [GameInfoGlobal sharedGameInfoGlobal].playerStartsWithShield = YES;
                [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                    at:STATS_START_WITH_SHIELD] tick];
                break;
                
            case DOUBLE_COINS:
                [GameInfoGlobal sharedGameInfoGlobal].coinValue = 2;
                [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                    at:STATS_DOUBLE_COINS] tick];
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
    if (isChoosen) {
        
        [[GameInfoGlobal sharedGameInfoGlobal] AddCoinsToBank:cost];
        self.isChoosen = NO;
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
    if (self.isChoosen)
    {
        return IS_AVAIL_ALREADY_CHOOSEN;
    }
    
    if ([[GameInfoGlobal sharedGameInfoGlobal] NumPowersSelected] >= 3)
    {
        return IS_AVAIL_POWER_LIST_FULL;
    }
    
    if ([GameInfoGlobal sharedGameInfoGlobal].coinsInBank < cost)
    {
        return IS_AVAIL_NOT_ENOUGH_MONEY;
    }
    
    return IS_AVAIL_OK;
//    return ((self.isChoosen != YES) && [GameInfoGlobal sharedGameInfoGlobal].coinsInBank > cost);
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
