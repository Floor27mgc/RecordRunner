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
@synthesize finalMultiplierLabel;
@synthesize highScoreLabel;
@synthesize emailView;
@synthesize emailViewController;
@synthesize isQuitting;

- (void) pressedNO:(id) sender
{
    NSLog(@"pressed no!");
    
    exit(0);

}

- (void) pressedYES:(id) sender
{
    self.isQuitting = NO;
    
    CCBAnimationManager* animationManager = self.userObject;
    NSLog(@"animationManager: %@", animationManager);
    [[GameLayer sharedGameLayer] resumeSchedulerAndActions];
    [animationManager runAnimationsForSequenceNamed:@"Pop out"];
    [[GameLayer sharedGameLayer] cleanUpPlayField];
    [[GameLayer sharedGameLayer].score setScoreValue:0];
    
}


//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData:(int) finalMultiplier finalScore:(int)myFinalScore
           highScore:(int) myHighScore
{
    NSLog(@"value of finalScoreLabel: %@", self.finalScoreLabel.string);
    
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed++;
    [[GameInfoGlobal sharedGameInfoGlobal] logLifeTimeAchievements];
    [[GameInfoGlobal sharedGameInfoGlobal] resetPerLifeStatistics];
    
    // reset the multiplier
    [[GameLayer sharedGameLayer].multiplier reset];
    
    [self.finalScoreLabel setString:[NSString stringWithFormat:@"%d",
                                         myFinalScore]];
    [self.finalMultiplierLabel setString:[NSString stringWithFormat:@"x%d",
                                     finalMultiplier]];
    [self.highScoreLabel setString:[NSString stringWithFormat:@"%d",
                                    myHighScore]];
    
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
    NSLog(@"pressed HOME!");
    self.isQuitting = YES;
    
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"Pop out"];
    
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
//    [[GameLayer sharedGameLayer] unschedule:@selector(update:)];
//    [[CCDirector sharedDirector] pause];
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
