//
//  AchievementContainer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import "AchievementContainer.h"

@implementation AchievementContainer

@synthesize allAchievements;
@synthesize currentAchievements;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        
        // load the number of achievements
        NSString * numAchievements = NSLocalizedString(@"NUMBER_OF_ACHIEVEMENTS", nil);
        NSInteger intNumAch = [numAchievements integerValue];
        NSLog(@"Number of achievements %d", intNumAch);
        allAchievements = [[NSMutableArray alloc] initWithCapacity: intNumAch];
        
        // load number of achievements per rank
        NSString * achievementsPerRank = NSLocalizedString(@"ACHIEVEMENTS_PER_RANK",
                                                            nil);
        NSInteger intPerRank = [achievementsPerRank integerValue];
        NSLog(@"Achievements per rank %@", achievementsPerRank);
        currentAchievements = [[NSMutableArray alloc] initWithCapacity: intPerRank];
        
        // load all the achievements
        for (int i = 1; i <= intNumAch; ++i) {
            NSString * curDesc = [NSString stringWithFormat:@"%@%d", @"DESC_", i];
            NSString * desc = NSLocalizedString(curDesc, nil);
            
            NSString * curCond = [NSString stringWithFormat:@"%@%d", @"COND_", i];
            NSString * cond = NSLocalizedString(curCond, nil);
            
            // load up all the achievements
            Achievement * newAchievement = [[Achievement alloc]
                                            initWithCondition:cond description:desc];

            [allAchievements addObject:newAchievement];
            
            // load up the first rank's achievements
            if (i <= intPerRank) {
                [currentAchievements addObject:newAchievement];
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
    for (Achievement * achievement in currentAchievements) {
        if ([achievement Achieved]) {
            [achievement Log];
        }
    }
}

@end
