//
//  AchievementContainer.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import <Foundation/Foundation.h>
#import "Achievement.h"

@interface AchievementContainer : NSObject

- (void) LoadRankAchievements: (int) rank;
- (Achievement *) GetAchievementByDescription: (NSString *) desc;
- (void) LoadCurrentRankAchievements;
- (BOOL) CheckCurrentAchievements;
- (void) LogAchievements;
- (void) LoadInternalAchievements;

@property (nonatomic, strong) NSMutableArray * allAchievements;
@property (nonatomic, strong) NSMutableArray * currentAchievements;
@property (nonatomic, strong) NSMutableArray * currentRankAchievements;
@property (nonatomic, assign) int numAchievementsPerRank;
@property (nonatomic, assign) int totalNumAchievements;
@property (nonatomic, assign) int currentRank;
@property (nonatomic, strong) NSMutableDictionary * achievementsDictionary;
@property (nonatomic, assign) BOOL achievementsLoaded;

@end
