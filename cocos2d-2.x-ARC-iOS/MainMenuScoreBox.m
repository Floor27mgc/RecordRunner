//
//  MainMenuScoreBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/2/13.
//
//

#import "MainMenuScoreBox.h"
#import "common.h"

#import <UIKit/UIKit.h>

@implementation MainMenuScoreBox
@synthesize gameCenterView;
@synthesize gameCenterViewController;


// -----------------------------------------------------------------------------------
- (void) pressedGameCenter: (id)sender
{
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

// -----------------------------------------------------------------------------------
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [gameCenterView removeFromSuperview];
    gameCenterView = nil;
    gameCenterViewController = nil;
}

// -----------------------------------------------------------------------------------
- (void) pressedGameCenterAchievements: (id)sender
{
    //GKGameCenterViewController * gcViewController = [[GKGameCenterViewController alloc] init];
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
    /*
    gameCenterViewController = [[UIViewController alloc]init];
    gameCenterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH, COMMON_SCREEN_HEIGHT)];
    gameCenterViewController.view = gameCenterView;
    [[[CCDirector sharedDirector] view] addSubview:gameCenterView];
    
    GKLeaderboardViewController *lb = [[GKLeaderboardViewController alloc] init];
    if(lb != nil){
        lb.leaderboardDelegate = self;
        [gameCenterViewController presentViewController:lb animated:YES completion:nil];
    }*/
}

// -----------------------------------------------------------------------------------
- (void)achievementViewControllerDidFinish:(GKGameCenterViewController *)gcViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [gameCenterView removeFromSuperview];
    gameCenterView = nil;
    gameCenterViewController = nil;
}

@end
