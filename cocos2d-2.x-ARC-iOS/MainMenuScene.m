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

@implementation MainMenuScene

- (id) init
{
    if( (self=[super init]) )
    {
        self.menuExpanded = NO;
        self.recommendedExpanded = NO;
        self.scoreExpanded = NO;
        self.buyExpanded = NO;
        self.socialExpanded = NO;
        self.settingsExpanded = NO;
        self.helpExpanded = NO;
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
    NSLog(@"recommend");
    self.recommendedExpanded = YES;
    [self closeMenus:self.recommendedExpanded];
}


- (void) pressedScore: (id)sender
{
    
    NSLog(@"score");
    
    self.scoreExpanded = YES;
    [self closeMenus:self.scoreExpanded];
}


- (void) pressedBuy: (id)sender
{
    
    NSLog(@"Buy");
    
    self.buyExpanded = YES;
    [self closeMenus:self.buyExpanded];
}


- (void) pressedSocial: (id)sender
{
    
    NSLog(@"Social");
    
    self.socialExpanded = YES;
    [self closeMenus:self.socialExpanded];
}


- (void) pressedSettings: (id)sender
{
    
    NSLog(@"settings");
    
    self.settingsExpanded = YES;
   [self closeMenus:self.settingsExpanded];
}


- (void) pressedHelp: (id)sender
{
    
    NSLog(@"help");
    
    self.helpExpanded = YES;
    [self closeMenus:self.helpExpanded];
}

- (void) closeMenus: (bool *) openThis
{
    CCBAnimationManager* animationManager = self.userObject;
    bool tempOpen = openThis;

    if (self.recommendedExpanded)
    {   
        self.recommendedExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"closeRecommended"];
    }
    if (self.scoreExpanded)
    {
        self.scoreExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"closeScore"];
    }
    if (self.buyExpanded)
    {
        self.buyExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"closeBuy"];
    }
    if (self.socialExpanded)
    {
        self.socialExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"closeSocial"];
    }
    if (self.settingsExpanded)
    {
        self.settingsExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"closeSettings"];
    }
    if (self.helpExpanded)
    {
        self.helpExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"closeHelp"];
    }

    openThis = tempOpen;
}


- (void) openMenus: (id) sender
{
    CCBAnimationManager* animationManager = self.userObject;
    
    if (self.recommendedExpanded)
    {
        [animationManager runAnimationsForSequenceNamed:@"openRecommended"];
    }
    if (self.scoreExpanded)
    {
        self.scoreExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"openScore"];
    }
    if (self.buyExpanded)
    {
        self.buyExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"openCloseBuy"];
    }
    if (self.socialExpanded)
    {
        self.socialExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"openSocial"];
    }
    if (self.settingsExpanded)
    {
        self.settingsExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"openSettings"];
    }
    if (self.helpExpanded)
    {
        self.helpExpanded = NO;
        [animationManager runAnimationsForSequenceNamed:@"openHelp"];
    }
    
}



@end
