//
//  BuyPowerupMenu.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 8/20/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <GameKit/GameKit.h>
#import "CCControlButton.h"
#import "math.h"

@interface BuyCoinsMenu : CCNode <CCBAnimationManagerDelegate,MFMailComposeViewControllerDelegate>

- (void) pressedBack:(id) sender;
- (void) setMenuData:(int) myCoinCount;
- (void) openMenu;

@property (nonatomic, strong) CCLabelTTF * coinCountLabel;

@property (nonatomic, strong) CCControlButton * backButton;

@end
