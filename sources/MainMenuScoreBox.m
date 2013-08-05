//
//  MainMenuScoreBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/2/13.
//
//

#import "MainMenuScoreBox.h"
#import "common.h"
#import "GameInfoGlobal.h"


#import <UIKit/UIKit.h>

@implementation MainMenuScoreBox
@synthesize gameCenterView;
@synthesize gameCenterViewController;


// -----------------------------------------------------------------------------------
// GAMECENTER FLAG PRESSED
- (void) pressedGameCenter: (id)sender
{
    
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"GCPressed"];

}

// -----------------------------------------------------------------------------------
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [gameCenterView removeFromSuperview];
    gameCenterView = nil;
    gameCenterViewController = nil;
}

// -----------------------------------------------------------------------------------
// THE ACHIEVEMENTS BUTTON
- (void) pressedGameCenterAchievements: (id)sender
{
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"AchPressed"];
}



// -----------------------------------------------------------------------------------
- (void) pressedReset: (id)sender
{
        // Clear all locally saved achievement objects.
    
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"ResetPressed"];
    

}


// -----------------------------------------------------------------------------------
- (void)achievementViewControllerDidFinish:(GKGameCenterViewController *)gcViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [gameCenterView removeFromSuperview];
    gameCenterView = nil;
    gameCenterViewController = nil;
}


// -----------------------------------------------------------------------------------
// For the YES NO Button
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        ///$$ TODO run ResetAllAchievements from achievementContainer
        
        // Clear all progress saved on Game Center
        [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog (@"Error clearing achievements");
             }
             
         }];
    } else {
        // be nice with the world, maybe initiate some Ecological action as a bonus
    }
}

// -----------------------------------------------------------------------------------
//This monitors when animations complete.
//When one is complete, then it calls the action that it should.
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if ([name compare:@"GCPressed"] == NSOrderedSame) {
        
        
        gameCenterViewController = [[UIViewController alloc]init];
        gameCenterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH, COMMON_SCREEN_HEIGHT)];
        gameCenterViewController.view = gameCenterView;
        [[[CCDirector sharedDirector] view] addSubview:gameCenterView];
        
        GKLeaderboardViewController *lb = [[GKLeaderboardViewController alloc] init];
        if(lb != nil){
            lb.leaderboardDelegate = self;
            [gameCenterViewController presentViewController:lb animated:YES completion:nil];
        }
        
           }
    else if( [name compare:@"AchPressed"] == NSOrderedSame)
    {
        
        gameCenterViewController = [[UIViewController alloc] init];
        gameCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH,
                                                                  COMMON_SCREEN_HEIGHT)];
        gameCenterViewController.view = gameCenterView;
        [[[CCDirector sharedDirector] view] addSubview:gameCenterView];
        
        if (gameCenterViewController != nil) {
            
            GKAchievementViewController * achView = [[GKAchievementViewController alloc] init];
            if (achView != nil) {
                achView.achievementDelegate = self;
                [gameCenterViewController presentViewController: achView
                                                       animated: YES
                                                     completion:nil];
            }
        }

       
        
    }
    else if( [name compare:@"ResetPressed"] == NSOrderedSame)
    {
        // create a simple alert with an OK and cancel button
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Do you want to reset your achievements and score?"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
        [alert show];
       
    }
}

@end
