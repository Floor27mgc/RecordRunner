//
//  Achievement.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject

- (id) initWithCondition:(NSString *) cond
             description:(NSString *) desc;
- (BOOL) Achieved;
- (void) Log;


@property (nonatomic, strong) NSString * achievementCondition;
@property (nonatomic, strong) NSString * achievementDescription;
@property (nonatomic) BOOL previouslyAchieved;

@end
