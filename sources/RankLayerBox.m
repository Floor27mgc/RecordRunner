//
//  RankLayerBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/6/13.
//
//

#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "RankLayerBox.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import <GameKit/GameKit.h>

@implementation RankLayerBox
@synthesize isQuitting;


@synthesize rankLabel;
@synthesize goal1;
@synthesize goal2;
@synthesize goal3;

@synthesize rankLabel_B;
@synthesize goal1_B;
@synthesize goal2_B;
@synthesize goal3_B;

@synthesize goal1_check;
@synthesize goal2_check;	
@synthesize goal3_check;


// -----------------------------------------------------------------------------------
//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values

NSMutableArray * futureGoals;

//GUI ELEMENTS
NSMutableArray * acomplishedThisRoundCheckmarks;
NSMutableArray * existingCheckmarks;
BOOL rankPromotion = NO;
int currentRankScore;
int nextRankForThisLayer;

- (void) setMenuData:(NSMutableArray *) thisRanksAchievements
    nextRanksAchievements: (NSMutableArray *) nextAchievements
     whatWasAchieved: (NSMutableArray *) thisWasAchieved
         currentRank: (int) myRank
        promoteRank: (BOOL) goNextRank
{
    currentRankScore = myRank;
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed++;
    [[GameInfoGlobal sharedGameInfoGlobal] logLifeTimeAchievements];
    
    // load the goals
    NSMutableArray * goals = thisRanksAchievements;
    rankPromotion = goNextRank;
    nextRankForThisLayer = rankPromotion + 1;
    futureGoals = nextAchievements;
    
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
- (void) pressedYES:(id) sender
{
    self.isQuitting = YES;
    
    //The card looks different after a promotion so check for it
    if (rankPromotion)
    {
        
            [[GameLayer sharedGameLayer].achievementContainer CheckRankAchievements];
            CCBAnimationManager* animationManager = self.userObject;
            [animationManager runAnimationsForSequenceNamed:@"PopOutRanked"];
            
        } //end if rank promotion
        else{
            CCBAnimationManager* animationManager = self.userObject;
            [animationManager runAnimationsForSequenceNamed:@"Pop out"];
        }
    
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

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    
    NSLog(@"Rank Layer Box DidLoad from ccb:");
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    NSLog(@"RankLayerBox Animation Running %@",name);
    
    if ([name compare:@"Pop out"] == NSOrderedSame ||
        [name compare:@"PopOutRanked"] == NSOrderedSame) {
        [[GameLayer sharedGameLayer] showGameOverLayer];
    }
    else if ([name compare:@"Pop in"] == NSOrderedSame) {
        
        //Pop the first animation off, then show the next one, then the next
        if ([existingCheckmarks count] > 0)
        {
            [[existingCheckmarks objectAtIndex: 0] showNewCheck];
            
            [existingCheckmarks removeObjectAtIndex: 0];
        }
        
        //Pop the first animation off, then show the next one, then the next
        if ([acomplishedThisRoundCheckmarks count] > 0)
        {
            [[acomplishedThisRoundCheckmarks objectAtIndex: 0] showNewCheck];
            
            [acomplishedThisRoundCheckmarks removeObjectAtIndex: 0];
        }
    }
    
}


//This is the list of checkmarks that already exist
//Just do a little animation sequence for them.
- (void)finishExistingCheckMarks
{
    //Pop the first animation off, then show the next one, then the next
    if ([existingCheckmarks count] > 0)
    {
        [[existingCheckmarks objectAtIndex: 0] showExistingCheck];
        
        [existingCheckmarks removeObjectAtIndex: 0];
    }
    else if ([existingCheckmarks count] <= 0 && [acomplishedThisRoundCheckmarks count] > 0)
    {
        [[acomplishedThisRoundCheckmarks objectAtIndex: 0] showNewCheck];
        
        [acomplishedThisRoundCheckmarks removeObjectAtIndex: 0];
    }
    
}

//After the existing checkmark animations complete, we have to call the achievements ones that are new
//Each Checkmark calls this to coninue going through the rest of the checkmarks.
//Called in GameObjectCheck.m because after all the checkmarks animations have run, run this
- (void)finishNewThisRoundCheckMarks
{
        //Pop the first animation off, then show the next one, then the next
        if ([acomplishedThisRoundCheckmarks count] > 0)
        {
            [[acomplishedThisRoundCheckmarks objectAtIndex: 0] showNewCheck];
            
            [acomplishedThisRoundCheckmarks removeObjectAtIndex: 0];
        }//Setup the RANK PROMOTION ANIMATION
        else if ([acomplishedThisRoundCheckmarks count] <= 0 && rankPromotion)
        {
            CCBAnimationManager* animationManager = self.userObject;
            
            
            [self.goal1_B setDimensions:CGSizeMake(220,65)];
            [self.goal1_B setPosition:CGPointMake(160, 183)];
            
            [self.goal2_B setDimensions:CGSizeMake(220,65)];
            [self.goal2_B setPosition:CGPointMake(160, 120)];
            
            [self.goal3_B setDimensions:CGSizeMake(220,65)];
            [self.goal3_B setPosition:CGPointMake(160, 60)];
            
            [[GameLayer sharedGameLayer].achievementContainer LoadCurrentRankGoals: currentRankScore+1];
            [self.rankLabel_B setString:[NSString stringWithFormat:@"%d", currentRankScore + 1]];
            
            
            
            
            if ([futureGoals count] > 0) {
                
                Achievement * goal = [futureGoals objectAtIndex:0];
                if (goal) {
                    
                    [self.goal1_B setString:[NSString stringWithFormat:@"%@",
                                             goal.achievementCondition]];
                }
                
                goal = [futureGoals objectAtIndex:1];
                if (goal) {
                    
                    [self.goal2_B setString:[NSString stringWithFormat:@"%@",
                                             goal.achievementCondition]];
                    
                }
                
                goal = [futureGoals objectAtIndex:2];
                if (goal) {
                    
                    [self.goal3_B setString:[NSString stringWithFormat:@"%@",
                                             goal.achievementCondition]];
                    
                }
            }//End if future goals

            
                
            [animationManager runAnimationsForSequenceNamed:@"RankUp"];
                
       }

}

@end
