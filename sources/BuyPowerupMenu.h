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
#import "BuyCoinsMenu.h"
#import "math.h"

@interface BuyPowerupMenu : CCNode <CCBAnimationManagerDelegate,MFMailComposeViewControllerDelegate>

- (void) pressedGetMore:(id) sender;
- (void) pressedPowerButton:(id) sender;
- (void) pressedPlay:(id) sender;
- (void) setMenuData:(int) myCoinCount;
           
- (void) pressedFeedback:(id)sender;
- (void) openMenu;
- (void) pressedFB:(id) sender;



@property BOOL isQuitting;

@property (nonatomic, strong) CCSprite * circleLeft;
@property (nonatomic, strong) CCSprite * circleMid;
@property (nonatomic, strong) CCSprite * circleRight;

@property (nonatomic, strong) CCLabelTTF * coinCountLabel;
@property (nonatomic, strong) CCControlButton * yesButton;
@property (nonatomic, strong) CCControlButton * getMoreButton;
@property (nonatomic, strong) BuyCoinsMenu * buyCoinsMenu;
@property (nonatomic, strong) NSMutableArray * currentPowers;

@end
