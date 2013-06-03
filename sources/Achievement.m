//
//  Achievement.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import "Achievement.h"

@implementation Achievement

@synthesize achievementCondition;
@synthesize achievementDescription;
@synthesize previouslyAchieved;

// -----------------------------------------------------------------------------------
- (id) initWithCondition:(NSString *)cond description:(NSString *)desc
{
    if (self=[super init]) {
        achievementCondition = cond;
        achievementDescription = desc;
        
        // this needs to be loaded from game center's achievements
        previouslyAchieved = NO;
    }
    
    return (self);
}

// -----------------------------------------------------------------------------------
- (BOOL) Achieved
{
    return (previouslyAchieved || [achievementCondition boolValue]);
}

// -----------------------------------------------------------------------------------
- (void) Log
{
    
}

@end
