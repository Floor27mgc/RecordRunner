//
//  Achievement.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import "Achievement.h"
#import "GameInfoGlobal.h"
#import "GameLayer.h"

@implementation Achievement

//@synthesize achievementCondition;
@synthesize achievementDescription;
@synthesize previouslyAchieved;
@synthesize condIndex;
@synthesize alreadyLogged;
@synthesize gcAchievement;
@synthesize isGCAchievement;

// -----------------------------------------------------------------------------------
- (id) initWithCondition:(int)index
             description:(NSString *)desc
                gameCenterAchievement:(GKAchievement *)gcAch
                    isGCAchievement:(BOOL) isGCAch
{
    if (self=[super init]) {
        //achievementCondition = cond;
        condIndex = index;
        achievementDescription = desc;
        gcAchievement = gcAch;
        isGCAchievement = isGCAch;
        
        if (isGCAchievement && gcAchievement.percentComplete == 100.0) {
            previouslyAchieved = YES;
            alreadyLogged = YES;
        } else {
            previouslyAchieved = NO;
            alreadyLogged = NO;
        }
    }
    
    return (self);
}

// -----------------------------------------------------------------------------------
- (BOOL) Achieved
{
    if (previouslyAchieved) {
        return YES;
    }
    
    BOOL achieved = NO;
    
    switch (condIndex) {
            // Go 10 Laps in a single life.
        /*case 1:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife
                        >= 10);
            break;
            
            // Collect 50 coins in a single life.
        case 2:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife >= 50);
            break;
            
            // Skim past 3 “X’s” in a single life.
        case 3:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].closeCallsThisLife >= 3);
            break;
            
            // Collect 3 coins in a single scratch.
        case 4:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch >= 3);
            break;
            
            // Get a score of 200.
        case 5:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].score >= 200);
            break;
            
            // Survive for 60 seconds without dying.
        case 6:
            achieved = ([[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                        getCurrentGameTimeElapsed] > 60);
            break;
            
            // Kill 4 bombs with a shield.
        case 7:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield >=4);
            break;
            
            // Spin the same bomb Clockwise then immediately Counter clockwise.
        case 8:
            break;
            
            // Get a score of 1000.
        case 9: 
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].score >= 1000);
            break;
            
            // Go 30 laps in a single life.
        case 10:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife
                        >= 30);
            break;
            
            // In a single life get a x10 multiplier then drop it to x1.
        case 11:
            achieved =
            (([[GameLayer sharedGameLayer].multiplier highestMultiplierValueEarned] >= 10)
             && [[GameLayer sharedGameLayer].multiplier getMultiplier] == 1);
            break;
            
            // Maintain a multiplier of at least x10 for 2 minutes.
        case 12:
            achieved = ([[GameLayer sharedGameLayer].multiplier secondsAbove10x] > 120);
            break;
            
            // In a single life, spend a total of 2 minutes in the outer ring.
        case 13:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].timeInOuterRingThisLife
                        >= 120);
            break;
            
            // Scratch 40 times in a single revolution.
        case 14:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].scratchesThisRevolution >= 40);
            break;
            
            // UNKNOWN
        case 15:
            break;*/
            
            // Rank 1
        case 16:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife >= 10) &&
                        ([GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife >= 50) &&
                        ([GameInfoGlobal sharedGameInfoGlobal].closeCallsThisLife >= 3);
            break;
            
            // Rank 2
        case 17:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].coinsThisScratch >= 3) &&
                        ([GameInfoGlobal sharedGameInfoGlobal].score >= 200) &&
                        ([[GameInfoGlobal sharedGameInfoGlobal].statsContainer
                         getCurrentGameTimeElapsed] > 60);
            break;
            
            // Rank 3
        case 18:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield >=4) &&
                        ([GameInfoGlobal sharedGameInfoGlobal].score >= 1000);
            break;
            
            // Rank 4
        case 19:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife
                        >= 30) &&
                        (([[GameLayer sharedGameLayer].multiplier highestMultiplierValueEarned]
                          >= 10)
                         && [[GameLayer sharedGameLayer].multiplier getMultiplier] == 1) &&
                        ([[GameLayer sharedGameLayer].multiplier secondsAbove10x] > 120);
            break;
            
            // Rank 5
        case 20:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].timeInOuterRingThisLife >= 120) &&
                        ([GameInfoGlobal sharedGameInfoGlobal].scratchesThisRevolution >= 40);
            break;
            
            // After earning rank 5, cash out and start over
        case 21:
            // MECHANISMS NOT IN PLACE -- HIDDEN ON GAME CENTER
            break;
            
            // After cashing out, earn rank 5 again
        case 22:
            // MECHANISMS NOT IN PLACE -- HIDDEN ON GAME CENTER
            break;
            
            // Play 15 rounds of rotato
        case 23:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed >= 15);
            break;
            
            // Go 1000 total revolutions
        case 24:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].lifetimeRevolutions >= 1000);
            break;
            
            // Collect 1000 coins
        case 25:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].coinsInBank >= 1000);
            break;
            
            // Collect 5000 coins
        case 26:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].coinsInBank >= 5000);
            break;
            
            // Collect 1000000 coins
        case 27:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].coinsInBank >= 1000000);
            break;
            
            // Go 40 revolutions in a single life
        case 28:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife >= 40);
            break;
            
            // Go 70 revolutions in a single life
        case 29:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife >= 70);
            break;
            
            // Go 100 revolutions in a single life
        case 30:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotationsThisLife >= 100);
            break;
            
            // Get a multiplier of 10
        case 31:
            achieved = ([[GameLayer sharedGameLayer].multiplier getMultiplier] >= 10);
            break;
            
            // Get a multiplier of 20
        case 32:
            achieved = ([[GameLayer sharedGameLayer].multiplier getMultiplier] >= 20);
            break;
            
            // Get a multiplier of 30
        case 33:
            achieved = ([[GameLayer sharedGameLayer].multiplier getMultiplier] >= 30);
            break;
            
            // Kill 5 bombs with a single shield
        case 34:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield >= 5);
            break;
            
            // Kill 10 bombs with a single shield
        case 35:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield >= 10);
            break;
            
            // Kill 15 bombs with a single shield
        case 36:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield >= 15);
            break;

        default:
            return NO;
            break;
    }
    
    // once achieved, set the flag
    if (achieved) {
        NSLog(@"achieved %@!", achievementDescription);
        
        //$$$ACHIEVE THIS ONE/////
        
        if (isGCAchievement) {
            gcAchievement.percentComplete = 100.0;
        }
        
        previouslyAchieved = YES;
    }
    
    return achieved;
}

// -----------------------------------------------------------------------------------
- (void) Log
{
    if (!alreadyLogged) {
        if (isGCAchievement) {
            NSLog(@"logging GC achievement %@ with percent complete %f",
                  achievementDescription, gcAchievement.percentComplete);
            [gcAchievement reportAchievementWithCompletionHandler:^(NSError *error)
             {
                 if (error != nil)
                 {
                     NSLog(@"Error in reporting achievement: %@", error);
                 }
             }];
        }
        alreadyLogged = YES;
    }
}

@end
