//
//  AchievementContainer.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import <Foundation/Foundation.h>
#import "Achievement.h"

#define ACHIEVEMENTS_PER_RANK 3
#define NUM_RANKS             5

@interface AchievementContainer : NSObject

- (Achievement *) GetAchievementByDescription: (NSString *) desc;
- (Achievement *) GetAchievementByIdentifier: (int) identifier;
- (BOOL) CheckCurrentAchievements;
- (void) LogAchievements;
- (void) LoadInternalAchievements;
- (void) LoadInternalRankAchievements;

@property (nonatomic, strong) NSMutableArray * allAchievements;
@property (nonatomic, strong) NSMutableArray * currentAchievements;
@property (nonatomic, strong) NSMutableArray * currentRankAchievements;
@property (nonatomic, assign) int numAchievementsPerRank;
@property (nonatomic, assign) int totalNumAchievements;
@property (nonatomic, assign) int currentRank;
@property (nonatomic, strong) NSMutableDictionary * achievementsDictionary;
@property (nonatomic, assign) BOOL achievementsLoaded;

@end
