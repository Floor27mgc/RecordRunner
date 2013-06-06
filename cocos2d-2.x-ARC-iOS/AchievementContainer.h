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

- (BOOL) CheckCurrentAchievements;
- (void) LogAchievements;

@property (nonatomic, strong) NSMutableArray * allAchievements;
@property (nonatomic, strong) NSMutableArray * currentAchievements;
@property (nonatomic, assign) int numAchievementsPerRank;
@property (nonatomic, assign) int totalNumAchievements;

@end
