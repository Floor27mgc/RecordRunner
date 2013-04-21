//
//  MainMenuScene.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "MainMenuRecommendBox.h"
#import "MainMenuScoreBox.h"
#import "MainMenuBuyBox.h"
#import "MainMenuSocialBox.h"
#import "MainMenuSettingsBox.h"
#import "MainMenuHelpBox.h"


@interface MainMenuScene : CCLayer

@property (nonatomic,assign) BOOL menuExpanded;

@property (nonatomic, strong) MainMenuRecommendBox * mainMenuRecommend;
@property (nonatomic, strong) MainMenuScoreBox * mainMenuScore;
@property (nonatomic, strong) MainMenuBuyBox * mainMenuBuy;
@property (nonatomic, strong) MainMenuSocialBox * mainMenuSocial;
@property (nonatomic, strong) MainMenuSettingsBox * mainMenuSettings;
@property (nonatomic, strong) MainMenuHelpBox * mainMenuHelp;

@property  (nonatomic, strong) NSArray * buttonArray;


typedef NS_ENUM (NSUInteger, MainMenuButtons) {
    BUTTON_RECOMMEND,
    BUTTON_SCORE,
    BUTTON_BUY,
    BUTTON_SOCIAL,
    BUTTON_SETTINGS,
    BUTTON_HELP
};


@end
