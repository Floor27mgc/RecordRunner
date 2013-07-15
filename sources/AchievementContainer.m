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
@synthesize currentAchievements;    //??deprecated??
@synthesize numAchievementsPerRank; //The count of num achievements per rank.
@synthesize totalNumAchievements;
@synthesize achievementsDictionary;
@synthesize currentRankAchievements; //The 3 achievements in the current rank you are trying to achieve
@synthesize currentRank;
@synthesize achievementsLoaded;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        
        achievementsLoaded = NO;
        
        // load the number of achievements
        NSString * numAchievements = NSLocalizedStringFromTable(@"NUMBER_OF_ACHIEVEMENTS",
                                                                @"achievement_map",
                                                                nil);
        totalNumAchievements = [numAchievements integerValue];

        allAchievements = [[NSMutableArray alloc] initWithCapacity: totalNumAchievements];
        
        // load number of achievements per rank
        NSString * achievementsPerRank = NSLocalizedStringFromTable(@"ACHIEVEMENTS_PER_RANK",
                                                                    @"achievement_map",                                                            nil);
        numAchievementsPerRank = [achievementsPerRank integerValue];

        currentAchievements = [[NSMutableArray alloc] initWithCapacity:
                               numAchievementsPerRank];
        
        currentRankAchievements = [[NSMutableArray alloc] initWithCapacity:
                               numAchievementsPerRank];
        
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
                 NSLog(@"registering achievement with id %@", achievement.identifier);
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
                                        gameCenterAchievement:curAch
                                        isGCAchievement:YES];
        
        [allAchievements addObject:newAchievement];
        ++conditionIndex;
        
        // load into current, if achievement not already achieved
        if (curAch.percentComplete < 100) {
            [currentAchievements addObject:newAchievement];
        }
        
    }
    
    //Set the current rank number

    //[self LoadCurrentRankAchievements];
    //And adds all the achievements that are need for that rank to the array currentRankAchievements
}

// -----------------------------------------------------------------------------------
//Gives you an achievement when you give it an identifier
- (Achievement *) GetAchievementByIdentifier:(int)identifier
{
    int totalAchievementCount = totalNumAchievements +
        (NUM_RANKS * ACHIEVEMENTS_PER_RANK);
    
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
// This is called every update loop
- (void) LoadInternalRankAchievements
{
    int conditionIndex = 1;
    
    // load all the rank achievements
    for (int i = 1; i <= NUM_RANKS; ++i) {
        
        for (int j = 1; j <= ACHIEVEMENTS_PER_RANK; ++j) {
            
            NSString * curRankDesc = [NSString stringWithFormat:@"%@%d%@%d",
                                      @"RANK_", i, @"_DESC_", j];
            NSString * rankDesc = NSLocalizedStringFromTable(curRankDesc,
                                                             @"achievement_map",                                                            nil);
            
            
            NSString * rankConditionTag = [NSString stringWithFormat:@"%@%d%@%d",
                                           @"RANK_", i, @"_COND_", i];
            NSString * rankCond = NSLocalizedStringFromTable(rankConditionTag,
                                                             @"achievement_map",                                                            nil);
            
            //$$$
            // load up all the achievements
            Achievement * newAchievement = [[Achievement alloc]
                                            initWithCondition:conditionIndex
                                            condition:rankCond
                                            description:rankDesc
                                            gameCenterAchievement:nil
                                            isGCAchievement:NO];
            
            [allAchievements addObject:newAchievement];
            ++conditionIndex;
        }
    }
}


// -----------------------------------------------------------------------------------
// Called from LoadCurrentRankAchievements, creates a 3 array based on current rank.
// These are not GC achivements so you have to do a custom making of them.
/*- (void) LoadRankAchievements:(int)rank
{
    int conditionIndex  = 16;
    
    for (int i = 1; i <= numAchievementsPerRank; ++i) {
        
        //Rank Condition
        NSString * rankConditionTag = [NSString stringWithFormat:@"%@%d%@%d",
                                       @"RANK_", rank, @"_COND_", i];
        NSString * rankCond = NSLocalizedStringFromTable(rankConditionTag,
                                                         @"achievement_map",                                                            nil);
        
        //Description
        NSString * curRankDesc = [NSString stringWithFormat:@"%@%d%@%d",
                                  @"RANK_", rank, @"_DESC_", i];
        NSString * rankDesc = NSLocalizedStringFromTable(curRankDesc,
                                                         @"achievement_map",                                                            nil);
        
        
        
        Achievement * newAchievement = [[Achievement alloc]
                                        initWithCondition:1
                                        condition: rankCond
                                        description:rankDesc
                                        gameCenterAchievement:nil
                                        isGCAchievement:NO];
        
        [currentRankAchievements addObject:newAchievement];
        
        
        
        // $$$ The following returns nil because it is searching allachievements list for rankDesc. However, the non-gc achievements (those sub rank-achievements) are not in the allachivements list
        
        //        So I think this method should just create a 3-part array. here.
        
        //        [currentRankAchievements addObject:[self GetAchievementByDescription:rankDesc]];
    }
    
    return;
}*/


// ----------------------------------------------------------------------------------
// Sets your current rank based on what percent complete you are with the rank achievements.

/*- (void) LoadCurrentRankAchievements
// Also populates the rank achievements
- (void) LoadCurrentRankAchievements
{
    GKAchievement * ach = [achievementsDictionary objectForKey:@"16"];
    if (ach.percentComplete < 100) {
        NSLog(@"loading rank 1");
        [self LoadRankAchievements:1];
        currentRank = 1;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"17"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:2];
        currentRank = 2;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"18"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:3];
        currentRank = 3;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"19"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:4];
        currentRank = 4;
        return;
    }
    
    ach = [achievementsDictionary objectForKey:@"20"];
    if (ach.percentComplete < 100) {
        [self LoadRankAchievements:5];
        currentRank = 5;
        return;
    }
    
    currentRank = 0;
    
    return;
}*/

// -----------------------------------------------------------------------------------
// Called on every update in GameLayer.
- (BOOL) CheckCurrentAchievements
{
    if (!achievementsLoaded) {
        [self LoadInternalRankAchievements];
        [self LoadInternalAchievements];
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

@end
