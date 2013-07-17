//
//  Achievement.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

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
@property (nonatomic, assign) int condIndex;
@property (nonatomic, strong) GKAchievement * gcAchievement;
@property (nonatomic, assign) double percentAchieved;

@end
