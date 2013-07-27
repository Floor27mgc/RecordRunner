//
//  RankLayerSubBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/25/13.
//
//

#import "RankLayerSubBox.h"
#import "GameLayer.h"
#import "GameInfoGlobal.h"

@implementation RankLayerSubBox


@synthesize rankLabel;
@synthesize goal1;
@synthesize goal2;
@synthesize goal3;


@synthesize goal1_check;
@synthesize goal2_check;
@synthesize goal3_check;



// -----------------------------------------------------------------------------------
- (id) init
{
     self = [super init];
    
     if (!self) return NULL;
    
    return self;
    
}

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
}


NSMutableArray * acomplishedThisRoundCheckmarks;
int currentRankScore;
NSMutableArray * existingCheckmarks;


- (void) setMenuData:(NSMutableArray *) thisRanksAchievements
     whatWasAchieved: (NSMutableArray *) thisWasAchieved
         currentRank: (int) myRank
{
    currentRankScore = myRank;
    
    // load the goals
    NSMutableArray * goals = thisRanksAchievements;
    
    acomplishedThisRoundCheckmarks = [[NSMutableArray alloc] initWithCapacity:3];
    
    [self.goal1 setDimensions:CGSizeMake(220,65)];
    [self.goal1 setPosition:CGPointMake(160, 183)];
    
    [self.goal2 setDimensions:CGSizeMake(220,65)];
    [self.goal2 setPosition:CGPointMake(160, 120)];
    
    [self.goal3 setDimensions:CGSizeMake(220,65)];
    [self.goal3 setPosition:CGPointMake(160, 60)];
    
    if ([goals count] > 0) {
        
        NSString * goalState = @"-";
        
        Achievement * goal = [goals objectAtIndex:0];
        if (goal) {
            
            goalState = @"1 ";
            
            if ([self wasThisAchieved:goal])
            {
                [acomplishedThisRoundCheckmarks addObject:self.goal1_check];
            }
            else if ([goal previouslyAchieved] && ![self wasThisAchieved:goal])
            {
                goalState = [goalState stringByAppendingString:@"ACHIEVED - "];
                [existingCheckmarks addObject:self.goal1_check];
            }
            
            
            goalState = [goalState stringByAppendingString: [NSString stringWithFormat:@"%@",
                                                             goal.achievementCondition]];
            
            [self.goal1 setString:goalState];
        }
        
        goal = [goals objectAtIndex:1];
        if (goal) {
            
            goalState = @"2 ";
            
            if ([self wasThisAchieved:goal])
            {
                [acomplishedThisRoundCheckmarks addObject:self.goal2_check];
            }
            else if ([goal previouslyAchieved] && ![self wasThisAchieved:goal])
            {
                goalState = [goalState stringByAppendingString:@"ACHIEVED - "];
                [existingCheckmarks addObject:self.goal2_check];
            }
            goalState = [goalState stringByAppendingString: [NSString stringWithFormat:@"%@",
                                                             goal.achievementCondition]];
            
            [self.goal2 setString:goalState];
            
        }
        
        goal = [goals objectAtIndex:2];
        if (goal) {
            
            
            goalState = @"3 ";
            
            //Achieved this time
            if ([self wasThisAchieved:goal])
            {
                [acomplishedThisRoundCheckmarks addObject:self.goal3_check];
            }//Achieved but not this round
            else if ([goal previouslyAchieved] && ![self wasThisAchieved:goal])
            {
                goalState = [goalState stringByAppendingString:@"ACHIEVED - "];
                [existingCheckmarks addObject:self.goal3_check];
            }
            goalState =  [goalState stringByAppendingString: [NSString stringWithFormat:@"%@",
                                                              goal.achievementCondition]];
            
            [self.goal3 setString:goalState];
            
        }
    }
    
    [self.rankLabel setString:[NSString stringWithFormat:@"%d",
                               currentRankScore]];
    
}

// -----------------------------------------------------------------------------------
// Used to see if an achivement was reached this round so we can do the fancy new animation
- (BOOL) wasThisAchieved: (Achievement *) thisAchievement
{
    NSMutableArray * achieved = [GameInfoGlobal sharedGameInfoGlobal].achievedThisRound;
    
    for(Achievement * ach in achieved)
    {
        if (ach.condIndex == thisAchievement.condIndex)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void) testMethod
{
    NSLog(@"testMethod in RankLayerSubBox");
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    //After $$.
    if ([name compare:@"Blip"] == NSOrderedSame) {
        
    }//Go $$$$
    else if ([name compare:@"AlreadyAchieved"] == NSOrderedSame)
    {
        
        
    }
}



@end
