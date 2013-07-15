//
//  GameOverLayer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/17/12.
//
//

#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "GameOverLayer.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import <GameKit/GameKit.h>

@implementation GameOverLayer
@synthesize finalScoreLabel;
@synthesize emailView;
@synthesize emailViewController;
@synthesize isQuitting;
@synthesize rankLabel;
@synthesize yesButton;
@synthesize yesButtonEnabled;
@synthesize homeButtonEnabled;
@synthesize goal1;
@synthesize goal2;
@synthesize goal3;


- (void) pressedNO:(id) sender
{
    NSLog(@"pressed no!");
    
    exit(0);

}

- (void) pressedYES:(id) sender
{
    if (yesButtonEnabled)
    {
    self.isQuitting = NO;
    
    [self turnOffButtons];
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [[GameLayer sharedGameLayer] resumeSchedulerAndActions];
    [animationManager runAnimationsForSequenceNamed:@"Pop out"];
    [[GameLayer sharedGameLayer] cleanUpPlayField];
    [[GameLayer sharedGameLayer].score setScoreValue:0];
    }
}


//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData:(int) myFinalScore
           rankLevel:(int) rankScore

{
    
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed++;
    [[GameInfoGlobal sharedGameInfoGlobal] logLifeTimeAchievements];
    [[GameInfoGlobal sharedGameInfoGlobal] resetPerLifeStatistics];
    
    // reset the multiplier
    [[GameLayer sharedGameLayer].multiplier reset];
    
    [self.finalScoreLabel setString:[NSString stringWithFormat:@"%d",
                                         myFinalScore]];
    
    [self.rankLabel setString:[NSString stringWithFormat:@"%d",
                                     rankScore]];
    
    NSMutableArray * rankAchievements = [[GameLayer sharedGameLayer].achievementContainer currentRankAchievements];
        
    //70 is good but not perfect
    //float xPosition = [self.goal1 position].x;
    float textHeight = [self.goal1 dimensions].height;
    
    [self.goal1 setDimensions:CGSizeMake(220,65)];
    [self.goal1 setPosition:CGPointMake(160, 183)]; 
    
    [self.goal2 setDimensions:CGSizeMake(220,65)];
    [self.goal2 setPosition:CGPointMake(160, 120)]; 
    
    [self.goal3 setDimensions:CGSizeMake(220,65)];
    [self.goal3 setPosition:CGPointMake(160, 60)]; 

    
    [self.goal1 setString:[NSString stringWithFormat:@"%@",
                           [(Achievement *)[rankAchievements objectAtIndex: 0] achievementCondition]]];
     [self.goal2 setString:[NSString stringWithFormat:@"%@",
     [(Achievement *)[rankAchievements objectAtIndex: 1] achievementCondition]]];
     
     [self.goal3 setString:[NSString stringWithFormat:@"%@",
     [(Achievement *)[rankAchievements objectAtIndex: 2] achievementCondition]]];
       
    
    GKScore *myScoreValue = [[GKScore alloc] initWithCategory:@"RotatoLeaderBoard"];
    myScoreValue.value = myFinalScore;
    
    [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
        if(error != nil){
            NSLog(@"Score Submission Failed");
        } else {
            NSLog(@"Score Submitted");
        }
        
    }];
}

//This quits the game
- (void) pressedHome:(id) sender
{
    if (homeButtonEnabled)
    {
        NSLog(@"pressed HOME!");
        self.isQuitting = YES;        
        
        [self turnOffButtons];
        
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"Pop out"];

    }
}

- (void) pressedFeedback:(id)sender
{
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"Rotato feedback"];
    [mailViewController setToRecipients:[NSArray arrayWithObject:@"contact@floor27industries.com"]];
    
    [mailViewController setMessageBody:@"Comment:\n" isHTML:NO];
    
    emailViewController = [[UIViewController alloc]init];
    emailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH, COMMON_SCREEN_HEIGHT)];
    emailViewController.view = emailView;
    [[[CCDirector sharedDirector] view] addSubview:emailView];
    [emailViewController presentViewController:mailViewController animated:YES completion:nil];
    
}

- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
    yesButtonEnabled = NO;
    homeButtonEnabled = NO;
    
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    NSLog(@"%@",name);
    
    if ([name compare:@"Pop out"] == NSOrderedSame) {
        
        //If the player pressed quit then you need to go to the main menu
        if (isQuitting)
        {
            NSLog(@"POST ANIMATION: RUN THE QUIT!");
            // Load the mainMenu scene
            CCScene* mainMenuScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
            
            // Go to the game scene
            [[CCDirector sharedDirector] replaceScene:mainMenuScene];
        }        
        self.visible = NO;
    }
    else if ([name compare:@"Pop in"] == NSOrderedSame)
    {
        //Turn on the buttons after the menu finishes coming in.
        [self turnOnButtons];
    }
//    [[GameLayer sharedGameLayer] unschedule:@selector(update:)];
//    [[CCDirector sharedDirector] pause];
}

//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOffButtons
{
    
    //TODO: Figure out how to turn off the play button. It can be pressed repeatedly.
    yesButtonEnabled = NO;
    homeButtonEnabled = NO;
    
}

//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOnButtons
{
    
    //TODO: Figure out how to turn off the play button. It can be pressed repeatedly.
    yesButtonEnabled = YES;
    homeButtonEnabled = YES;
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [emailViewController dismissViewControllerAnimated:YES completion:nil];
    //[[[CCDirector sharedDirector] view] addSubview:emailView];
    [emailView removeFromSuperview];
    emailView = nil;
    emailViewController = nil;
    
}

@end
