//
//  AchievementContainer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import "AchievementContainer.h"
#import "GameInfoGlobal.h"

@implementation AchievementContainer

@synthesize allAchievements;
@synthesize currentAchievements;
@synthesize numAchievementsPerRank;
@synthesize totalNumAchievements;
@synthesize achievementsDictionary;
@synthesize currentRankAchievements;
@synthesize currentRank;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        
        // load the number of achievements
        NSString * numAchievements = NSLocalizedStringFromTable(@"NUMBER_OF_ACHIEVEMENTS",
                                                                @"achievement_map",
                                                                nil);
        totalNumAchievements = [numAchievements integerValue];
        NSLog(@"Number of achievements %d", totalNumAchievements);
        allAchievements = [[NSMutableArray alloc] initWithCapacity: totalNumAchievements];
        
        // load number of achievements per rank
        NSString * achievementsPerRank = NSLocalizedStringFromTable(@"ACHIEVEMENTS_PER_RANK",
                                                                    @"achievement_map",                                                            nil);
        numAchievementsPerRank = [achievementsPerRank integerValue];
        NSLog(@"Achievements per rank %d", numAchievementsPerRank);
        currentAchievements = [[NSMutableArray alloc] initWithCapacity:
                               numAchievementsPerRank];
        
        // load number of ranks
        NSString * numRanks = NSLocalizedStringFromTable(@"NUMBER_OF_RANKS",
                                                         @"achievement_map",                                                            nil);
        int intNumRanks = [numRanks integerValue];
        NSLog(@"Number of ranks %d", intNumRanks);
             
        // load up all the achievement progress from game center
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray * achievements,
                                                               NSError * error)
         {
             if (error == nil)
             {
                 for (GKAchievement * achievement in achievements) {
                     [achievementsDictionary setObject: achievement forKey:
                        achievement.identifier];
                 }
             }
         }];
        
        int conditionIndex = 1;
        // load the inner-rank achievements
        for (int i = 1; i <= intNumRanks; ++i) {
            for (int j = 1; j <= numAchievementsPerRank; ++j) {
                NSString * curRankDesc = [NSString stringWithFormat:@"%@%d%@%d",
                                       @"RANK_", i, @"_DESC_", j];
                NSString * rankDesc = NSLocalizedStringFromTable(curRankDesc,
                                                                 @"achievement_map",                                                            nil);
                // load up all the achievements
                Achievement * newAchievement = [[Achievement alloc]
                                                initWithCondition:conditionIndex
                                                description:rankDesc
                                                gameCenterAchievement:nil
                                                isGCAchievement:NO];
                
                [allAchievements addObject:newAchievement];
                ++conditionIndex;
            }
        }
        
        // load all the non-rank achievements
        for (int i = 1; i <= totalNumAchievements; ++i) {
            NSString * curDesc = [NSString stringWithFormat:@"%@%d", @"DESC_", i];
            NSString * desc = NSLocalizedStringFromTable(curDesc,
                                                         @"achievement_map",
                                                         nil);
           
            // load the game center achievement, creating it if necessary
            GKAchievement * curAch = [achievementsDictionary objectForKey:desc];
            
            if (curAch == nil) {
                curAch = [[GKAchievement alloc] initWithIdentifier:desc];
                [achievementsDictionary setObject:curAch
                                           forKey:curAch.identifier];
            }
            
            // load up all the achievements
            Achievement * newAchievement = [[Achievement alloc]
                                            initWithCondition:conditionIndex
                                            description:desc
                                            gameCenterAchievement:curAch
                                            isGCAchievement:YES];

            [allAchievements addObject:newAchievement];
            ++conditionIndex;
            
            // load into current, if achievement not already achieved
            if (curAch.percentComplete < 100) {
                [currentAchievements addObject:newAchievement];
            }
        }
        
        // load up the current rank's achievements
        [self LoadCurrentRankAchievements];
        
    }
    
    return (self);
}

// -----------------------------------------------------------------------------------
- (Achievement *) GetAchievementByDescription:(NSString *)desc
{
    for (int i = 0; i < [allAchievements count]; ++i) {
        Achievement * ach = [allAchievements objectAtIndex:i];

        if (ach.achievementDescription == desc) {
            return [allAchievements objectAtIndex:i];
        }
    }
    
    return nil;
}

// -----------------------------------------------------------------------------------
- (void) LoadRankAchievements:(int)rank
{
    for (int i = 1; i <= numAchievementsPerRank; ++i) {
        NSString * curRankDesc = [NSString stringWithFormat:@"%@%d%@%d",
                                  @"RANK_", rank, @"_DESC_", i];
        NSString * rankDesc = NSLocalizedStringFromTable(curRankDesc,
                                                         @"achievement_map",                                                            nil);
        
        [currentRankAchievements addObject:[self GetAchievementByDescription:rankDesc]];
    }
    
    return;
}

// -----------------------------------------------------------------------------------
- (void) LoadCurrentRankAchievements
{
    GKAchievement * ach = [achievementsDictionary objectForKey:@"1"];
    if (ach.percentComplete < 100) {
        NSLog(@"loading rank 1");
        [self LoadRankAchievements:1];
        currentRank = 1;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"2"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:2];
        currentRank = 2;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"3"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:3];
        currentRank = 3;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"4"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:4];
        currentRank = 4;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"5"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:5];
        currentRank = 5;
        return;
    }
    
    currentRank = 0;
    
    return;
}

// -----------------------------------------------------------------------------------
- (BOOL) CheckCurrentAchievements
{
    
    NSLog(@"there are %d current and %d currentRank achievements",
          [currentAchievements count], [currentRankAchievements count]);
    for (Achievement * achievement in currentAchievements) {
        if ([achievement Achieved]) {
            return YES;
        }
    }
    
    for (Achievement * achievement in currentRankAchievements) {
        if ([achievement Achieved]) {
            return YES;
        }
    }
    
    return NO;
}

// -----------------------------------------------------------------------------------
- (void) LogAchievements
{
    // log current normal achievements
    for (Achievement * achievement in currentAchievements) {
        if ([achievement Achieved]) {
            [achievement Log];
        }
    }
    
    // log current ranked achievements
    int numRankAchieved = 0;
    for (Achievement * ach in currentRankAchievements) {
        if ([ach Achieved]) {
            numRankAchieved++;
        }
    }
    
    // reload the current achievements if all current have been achieved
    if (numRankAchieved == [currentRankAchievements count]) {
        
        NSLog(@"Rank of achievements cleared!");
       
        [currentRankAchievements removeAllObjects];

        // register achievement completion with game center
        NSString * curRankDesc = [NSString stringWithFormat:@"%@%d",
                                  @"DESC_", currentRank];
        NSString * rankDesc = NSLocalizedStringFromTable(curRankDesc,
                                                         @"achievement_map",
                                                         nil);
        
        Achievement * ach = [self GetAchievementByDescription:rankDesc];
        ach.gcAchievement.percentComplete = 100;
        [ach Log];
        
        [self LoadCurrentRankAchievements];
    }
}

@end
