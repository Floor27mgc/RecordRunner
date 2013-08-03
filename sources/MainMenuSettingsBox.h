//
//  MainMenuSettingsBox.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/2/13.
//
//

#import "CCLayer.h"


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuBox.h"
#import "GameInfoGlobal.h"



@interface MainMenuSettingsBox : MenuBox

@property (nonatomic, strong) CCLabelTTF * musicButtonLabel;
@property (nonatomic, strong) CCLabelTTF * soundButtonLabel;


- (void) setToggleText: (BOOL) value;
- (void) setSoundToggleText: (BOOL) value;

@end
