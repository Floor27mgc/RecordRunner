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
        
        // load all the achievements
        for (int i = 1; i <= numAchievementsPerRank; ++i) {
            NSString * curDesc = [NSString stringWithFormat:@"%@%d", @"DESC_", i];
            NSString * desc = NSLocalizedStringFromTable(curDesc,
                                                         @"achievement_map",
                                                         nil);

            /*NSString * curCond = [NSString stringWithFormat:@"%@%d", @"COND_", i];
            NSString * cond = NSLocalizedStringFromTable(curCond,
                                                         @"achievement_map",
                                                         nil);*/
            
            // load up all the achievements
            Achievement * newAchievement = [[Achievement alloc]
                                            initWithCondition:i description:desc];

            [allAchievements addObject:newAchievement];
            
            // load up the first rank's achievements
            if (i <= numAchievementsPerRank) {
                [currentAchievements addObject:newAchievement];
                NSLog(@"current %d: desc - %@", i, desc);
            }
        }
        
    }
    
    return (self);
}

// -----------------------------------------------------------------------------------
- (BOOL) CheckCurrentAchievements
{
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
    int numAchieved = 0;
    for (Achievement * achievement in currentAchievements) {
        if ([achievement Achieved]) {
            [achievement Log];
            numAchieved++;
        }
    }
    
    // reload the current achievements if all current have been achieved
    if (numAchieved == [currentAchievements count]) {
        
        NSLog(@"Rank of achievements cleared!");
        
        [currentAchievements removeAllObjects];
        
        for (int i = numAchieved; i < numAchievementsPerRank; ++i) {
            [currentAchievements addObject:[allAchievements objectAtIndex:i]];
        }
    }
}

@end
