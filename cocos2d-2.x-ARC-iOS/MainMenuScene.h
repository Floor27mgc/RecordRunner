//
//  MainMenuScene.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"

@interface MainMenuScene : CCLayer

@property (nonatomic,assign) BOOL menuExpanded;
@property (nonatomic,assign) BOOL recommendedExpanded;
@property (nonatomic,assign) BOOL scoreExpanded;
@property (nonatomic,assign) BOOL buyExpanded;
@property (nonatomic,assign) BOOL socialExpanded;
@property (nonatomic,assign) BOOL settingsExpanded;
@property (nonatomic,assign) BOOL helpExpanded;


@end
