//
//  MainMenuScene.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h" 


#import "MenuBox.h"
#import "MainMenuRecommendBox.h"
#import "MainMenuScoreBox.h"
#import "MainMenuBuyBox.h"
#import "MainMenuSocialBox.h"
#import "MainMenuSettingsBox.h"
#import "MainMenuHelpBox.h"

#import "common.h"
#import <GameKit/GameKit.h>
@implementation MainMenuScene

@synthesize mainMenuRecommend;
@synthesize mainMenuScore;
@synthesize mainMenuBuy;
@synthesize mainMenuSocial;
@synthesize mainMenuSettings;
@synthesize mainMenuHelp;

@synthesize buttonArray;
@synthesize gameCenterViewController;
@synthesize gameCenterView;
@synthesize clickedStart;


- (id) init
{
    if( (self=[super init]) )
    {
        mainMenuRecommend = (MainMenuRecommendBox *)[CCBReader nodeGraphFromFile:@"MainMenuRecommendBox.ccbi"];
        
        mainMenuScore = (MainMenuScoreBox *)[CCBReader nodeGraphFromFile:@"MainMenuScoreBox.ccbi"];
        
        mainMenuBuy = (MainMenuBuyBox *)[CCBReader nodeGraphFromFile:@"MainMenuBuyBox.ccbi"];
        
        mainMenuSocial = (MainMenuSocialBox *)[CCBReader nodeGraphFromFile:@"MainMenuSocialBox.ccbi"];
        
        mainMenuSettings = (MainMenuSettingsBox *)[CCBReader nodeGraphFromFile:@"MainMenuSettingsBox.ccbi"];
        
        mainMenuHelp = (MainMenuHelpBox *)[CCBReader nodeGraphFromFile:@"MainMenuHelpBox.ccbi"];
        
        
        buttonArray = [NSArray arrayWithObjects:mainMenuRecommend, mainMenuScore, mainMenuBuy, mainMenuSocial, mainMenuSettings, mainMenuHelp, nil];
        
        //Click start makes sure we dont keep running the start animation.
        clickedStart = NO;
        
        GKLocalPlayer __unsafe_unretained *localPlayer = [GKLocalPlayer localPlayer];
        //[self loadAchievements];
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil)
            {
                gameCenterViewController = [[UIViewController alloc]init];
                gameCenterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH, COMMON_SCREEN_HEIGHT)];
                gameCenterViewController.view = gameCenterView;
                [[[CCDirector sharedDirector] view] addSubview:gameCenterView];
                [gameCenterViewController presentViewController:viewController animated:YES completion:nil];

            }
            else if (localPlayer.isAuthenticated)
            {
                NSLog (@"We are in ");
                //[self loadAchievements];
                //[self authenticatedPlayer: localPlayer];
            }
            else
            {
                //[self disableGameCenter];
            }
        };
        

    }
    return (self);
}


- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
}


- (void) loadAchievements
{
    NSMutableDictionary * achievementsDictionary = [[NSMutableDictionary alloc] init];
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         if (error == nil)
         {
             for (GKAchievement* achievement in achievements)
                 [achievementsDictionary setObject: achievement forKey: achievement.identifier];
         }
     }];
    
    
    NSLog(@"achievements size %d", achievementsDictionary.count);
}


- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController1
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [gameCenterView removeFromSuperview];
    gameCenterView = nil;
    gameCenterViewController = nil;
}
- (void) pressedPlay:(id)sender
{
    //Only open the game if the menu is closed
    if ([self anyAnyMenusOpen] == NO && clickedStart == NO)
    {
        CCBAnimationManager* animationManager = self.userObject;
        clickedStart = YES;
        [animationManager runAnimationsForSequenceNamed:@"ClickedStart"];        
       
    }
}

- (void) pressedExpandButton: (id)sender
{
    
    CCBAnimationManager* animationManager = self.userObject;
    
    if (self.menuExpanded)
    {
        self.menuExpanded = NO;
        [self closeAllMenus];
        [animationManager runAnimationsForSequenceNamed:@"Contract"];
    }
    else
    {
        self.menuExpanded = YES;
        [animationManager runAnimationsForSequenceNamed:@"Expand"];
    }
}

- (void) pressedRecommended: (id)sender
{
    if (self.menuExpanded)
    {
    NSLog(@"Pressed Recommend");
   [self openMenus: BUTTON_RECOMMEND];
    }
}


- (void) pressedHelp: (id)sender
{
    
    if (self.menuExpanded)
    {
    NSLog(@"Pressed Help");
    [self openMenus: BUTTON_HELP];
    }
}

- (void) pressedScore: (id)sender
{
    
    if (self.menuExpanded)
    {
    NSLog(@"Pressed SCORE");
    [self openMenus: BUTTON_SCORE];
    }
}

- (void) pressedBuy: (id)sender
{
    
    if (self.menuExpanded)
    {
    NSLog(@"Pressed BUY");
    [self openMenus: BUTTON_BUY];
    }
}


- (void) pressedSocial: (id)sender
{
    
    if (self.menuExpanded)
    {
    NSLog(@"Pressed Social");
    [self openMenus: BUTTON_SOCIAL];
    }
}


- (void) pressedSettings: (id)sender
{
    
    if (self.menuExpanded)
    {
    NSLog(@"Pressed SETTINGS");
    [self openMenus: BUTTON_SETTINGS];
    }
}

- (void) closeAllMenus
{
    for (MenuBox *eachButton in buttonArray)
    {
        if (eachButton.isOpen)
        {
            [eachButton closeTab:eachButton];
        }
    }
}



//This is used by the rotato start button. We don't want to start the game if you have another menu open
- (BOOL) anyAnyMenusOpen
{
    for (MenuBox *eachButton in buttonArray)
    {
        if (eachButton.isOpen)
        {
            return YES;
        }
    }

    return NO;
}

- (void) openMenus: (MainMenuButtons) openThisMenu
{
    NSLog(@"============= open %d ===================", openThisMenu);
    
    int menuCounter = 0;
    for (MenuBox *eachButton in buttonArray)
    {
        if (eachButton.isOpen)
        {
            //Bounce the menu because it is open
            if (menuCounter == openThisMenu)
            {
                //NSLog (@"BOUNCE this menu = %d", (MainMenuButtons)menuCounter );
                [eachButton bounceTab: eachButton];
            }
            else
            {
                //If it isn't the one you want, close it
              //  NSLog (@"CLOSE this menu = %d", (MainMenuButtons)menuCounter );
                [eachButton closeTab:eachButton];
            }
        }
        else 
        {
            //Open the tab because it is not open
            if (menuCounter == openThisMenu)
            {
                if (!eachButton.beenAdded)
                {
                    [self addChild:eachButton z:15];
                    eachButton.position = COMMON_SCREEN_CENTER;
                    eachButton.beenAdded = YES;
                }
                
                [eachButton openTab: eachButton];
                
                
            }
        }
        
        NSLog (@"Menu %d is open: %s", menuCounter, eachButton.isOpen?"true":"false");
        
        menuCounter ++;
        
    }
    
    NSLog(@"======================================");

    
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    NSLog(@"MainMenuScene %@",name);
    
    if ([name compare:@"ClickedStart"] == NSOrderedSame) {
        
        // Load the game scene
        CCScene* gameScene = [CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"];
        
        // Go to the game scene
        [[CCDirector sharedDirector] replaceScene:gameScene];
        
    }
}

@end
