//
//  Achievement.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#define RANK_1 16
#define RANK_2 17
#define RANK_3 18
#define RANK_4 19
#define RANK_5 20

@interface Achievement : NSObject

- (id) initWithCondition:(int) index
               condition: (NSString *) cond
             description:(NSString *) desc
   gameCenterAchievement:(GKAchievement *) gcAch;
- (BOOL) Achieved;
- (void) Log;
- (void) Reset;


@property (nonatomic, strong) NSString * achievementCondition;
@property (nonatomic, strong) NSString * achievementDescription;
@property (nonatomic) BOOL previouslyAchieved;
@property (nonatomic) BOOL alreadyLogged;
@property (nonatomic) BOOL isRankAchievement;
@property (nonatomic) BOOL isRankSubAchievement;
@property (nonatomic, assign) int condIndex;
@property (nonatomic, strong) GKAchievement * gcAchievement;
@property (nonatomic, assign) double percentAchieved;

@end
