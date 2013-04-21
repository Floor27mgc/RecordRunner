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

@implementation MainMenuScene

@synthesize mainMenuRecommend;
@synthesize mainMenuScore;
@synthesize mainMenuBuy;
@synthesize mainMenuSocial;
@synthesize mainMenuSettings;
@synthesize mainMenuHelp;

@synthesize buttonArray;

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
    }
    return (self);
}

- (void) pressedPlay:(id)sender
{
    // Load the game scene
    CCScene* gameScene = [CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"];
    
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:gameScene];
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
    NSLog(@"Pressed Recommend");
   [self openMenus: BUTTON_RECOMMEND];
}


- (void) pressedHelp: (id)sender
{
    NSLog(@"Pressed Help");
    [self openMenus: BUTTON_HELP];
}

- (void) pressedScore: (id)sender
{
    NSLog(@"Pressed SCORE");
    [self openMenus: BUTTON_SCORE];
}



- (void) pressedBuy: (id)sender
{
    NSLog(@"Pressed BUY");
    [self openMenus: BUTTON_BUY];
}


- (void) pressedSocial: (id)sender
{
    NSLog(@"Pressed Social");
    [self openMenus: BUTTON_SOCIAL];
}


- (void) pressedSettings: (id)sender
{
    NSLog(@"Pressed SETTINGS");
    [self openMenus: BUTTON_SETTINGS];
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
                    [self addChild:eachButton z:11];
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



@end
