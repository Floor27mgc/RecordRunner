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
@synthesize allRankGoals;
@synthesize currentAchievements;
@synthesize numAchievementsPerRank; //The count of num achievements per rank.
@synthesize totalNumAchievements;
@synthesize achievementsDictionary;
@synthesize currentRankGoals; // The 3 achievements in the current
                              // rank you are trying to achieve
@synthesize currentRank;
@synthesize achievementsLoaded;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        
        achievementsLoaded = NO;
        
        // load the number of achievements
        NSString * numAchievements = NSLocalizedStringFromTable(@"NUMBER_OF_ACHIEVEMENTS",
                                        @"achievement_map",                                  nil);
        totalNumAchievements = [numAchievements integerValue];

        allAchievements = [[NSMutableArray alloc] initWithCapacity: totalNumAchievements];
        
        // load number of achievements per rank
        NSString * achievementsPerRank = NSLocalizedStringFromTable(@"ACHIEVEMENTS_PER_RANK",
                                        @"achievement_map",
                                            nil);
        numAchievementsPerRank = [achievementsPerRank integerValue];

        currentAchievements = [[NSMutableArray alloc] init];
        
        allRankGoals = [[NSMutableArray alloc] initWithCapacity:
                               (GOALS_PER_RANK * NUM_RANKS)];
        
        currentRankGoals = [[NSMutableArray alloc] initWithCapacity:
                               (GOALS_PER_RANK * NUM_RANKS)];
        
        // load up all the achievement progress from game center
        achievementsDictionary = [[NSMutableDictionary alloc] init];
        
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray * achievements,
                                                               NSError * error)
         {
             if (error != nil)
             {
                 NSLog(@"ERROR is %@", [error localizedDescription]);
             }
             
             for (GKAchievement * achievement in achievements) {
                    [achievementsDictionary setObject: achievement forKey:
                    achievement.identifier];
             }
         }];
        
        achievementsLoaded = NO;
    }
    return  self;
}

// -----------------------------------------------------------------------------------
//Called every update. Internal achivements are all of them.
- (void) LoadInternalAchievements
{
    int conditionIndex = 16;
    
    // load all the non-rank achievements
    for (int i = 1; i <= totalNumAchievements; ++i) {
        NSString * curDesc = [NSString stringWithFormat:@"%@%d", @"DESC_", i];
        NSString * desc = NSLocalizedStringFromTable(curDesc,
                                                     @"achievement_map",
                                                     nil);
        NSString * identifier = [NSString stringWithFormat:@"%d", conditionIndex];
        
        
        
        NSString * rankConditionTag = [NSString stringWithFormat:@"%@%d%@%d",
                                       @"RANK_", i, @"_COND_", i];
        NSString * rankCond = NSLocalizedStringFromTable(rankConditionTag,
                                                         @"achievement_map",                                                            nil);
        
        // load the game center achievement, creating it if necessary
        GKAchievement * curAch = [achievementsDictionary objectForKey:identifier];
        
        if (curAch == nil) {
            curAch = [[GKAchievement alloc] initWithIdentifier:identifier];
            [achievementsDictionary setObject:curAch
                                       forKey:curAch.identifier];
            curAch.showsCompletionBanner = YES;
        }
        
        // add the achivement to the allAchivement List.
        Achievement * newAchievement = [[Achievement alloc]
                                        initWithCondition:conditionIndex
                                        condition: rankCond
                                        description:desc
                                        gameCenterAchievement:curAch];
        
        [allAchievements addObject:newAchievement];
        ++conditionIndex;
        
        // load into current, if achievement not already achieved
        if (curAch.percentComplete < 100) {
            [currentAchievements addObject:newAchievement];
        }
        
    }
}

// -----------------------------------------------------------------------------------
- (void) LoadInternalRankAchievements
{
    int conditionIndex = 1;
    
    // load all the rank achievements
    for (int i = 1; i <= NUM_RANKS; ++i) {
        
        for (int j = 1; j <= GOALS_PER_RANK; ++j) {
            
            NSString * curRankDesc = [NSString stringWithFormat:@"%@%d%@%d",
                                      @"RANK_", i, @"_DESC_", j];
            NSString * rankDesc = NSLocalizedStringFromTable(curRankDesc,
                                                             @"achievement_map",                                                            nil);
            
            
            NSString * rankConditionTag = [NSString stringWithFormat:@"%@%d%@%d",
                                           @"RANK_", i, @"_COND_", j];
            NSString * rankCond = NSLocalizedStringFromTable(rankConditionTag,
                                                             @"achievement_map",                                                            nil);

            NSString * identifier = [NSString stringWithFormat:@"%d", conditionIndex];
            
            // load the game center achievement, creating it if necessary
            GKAchievement * curAch = [achievementsDictionary objectForKey:identifier];
            
            if (curAch == nil) {
                curAch = [[GKAchievement alloc] initWithIdentifier:identifier];
                [achievementsDictionary setObject:curAch
                                           forKey:curAch.identifier];
                curAch.showsCompletionBanner = NO;
            }
            
            // add the achivement to the allAchivement List.
            Achievement * newAchievement = [[Achievement alloc]
                                            initWithCondition:conditionIndex
                                            condition: rankCond
                                            description: rankDesc
                                            gameCenterAchievement:curAch];
            
            ++conditionIndex;
            [allRankGoals addObject:newAchievement];
            [allAchievements addObject:newAchievement];
        }
    }
}

// -----------------------------------------------------------------------------------
//Gives you an achievement when you give it an identifier
- (Achievement *) GetAchievementByIdentifier:(int)identifier
{
    int totalAchievementCount = totalNumAchievements +
        (NUM_RANKS * GOALS_PER_RANK);
    
    // sanity check
    if (identifier < 1 || identifier > totalAchievementCount) {
        return nil;
    }
    
    for (Achievement * ach in allAchievements) {
        if (ach.condIndex == identifier) {
            return ach;
        }
    }
    
    return nil;
}

// -----------------------------------------------------------------------------------
// Parses all the achievements looking for the ones with a specific name.
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
// if useIndex is -1, find the next Achievement whose goals are not loaded, otherwise
// load goals from "useIndex"'s goals, if useIndex is -2, then we do not load anything
- (void) LoadCurrentRankGoals:(int) useIndex
{
    // remove the current rank's goals
    [currentRankGoals removeAllObjects];
    
    // do not load anything if -2 received
    if (useIndex == -2) {
        return;
    }
    
    // find which rank's goals to load
    int indexToLoad = useIndex;
    
    if (useIndex == -1) {
        int identifierIndex = 16;
        for (int i = 1; i <= NUM_RANKS; ++i) {
            Achievement * curAch = [self GetAchievementByIdentifier:identifierIndex];
            ++identifierIndex;
            
            if (![curAch Achieved]) {
                indexToLoad = i;
                break;
            }
        }
    }
    
    NSLog(@"Loading goals for rank %d", indexToLoad);
    
    // all ranks have been achieved
    if (indexToLoad == -1) {
        return;
    }
    
    // populate this rank's goals
    int startIndex = (indexToLoad - 1) * 3 + 1;
    for (int i = 0; i < GOALS_PER_RANK; ++i) {
        Achievement * curAch = [self GetAchievementByIdentifier:startIndex];
        ++startIndex;
        [currentRankGoals addObject:curAch];
    }
}

// -----------------------------------------------------------------------------------
// Called on every update in GameLayer.  Check the GC achievement status.
- (BOOL) CheckCurrentAchievements
{
    if (!achievementsLoaded) {
        [self LoadInternalRankAchievements];
        [self LoadInternalAchievements];
        [self LoadCurrentRankGoals:-1];
        
        achievementsLoaded = YES;
    }
    
    for (Achievement * achievement in currentAchievements) {
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
}

// -----------------------------------------------------------------------------------
- (BOOL) CheckRankGoals
{
    BOOL achievedAny = NO;
    for (Achievement * achievement in currentRankGoals) {
        if ([achievement Achieved]) {
            achievedAny = YES;
        }
    }
    
    return achievedAny;
}

// -----------------------------------------------------------------------------------
- (void) LogRankGoals
{
    for (Achievement * achievement in currentRankGoals) {
        if ([achievement Achieved]) {
            [achievement Log];
        }
    }
}

// -----------------------------------------------------------------------------------
- (void) ResetAllAchievements
{
    for (Achievement * achievement in allAchievements) {
        [achievement Reset];
    }
    
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             // handle errors
         }
    }];
}


@end
