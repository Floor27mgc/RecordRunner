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
#import "GuiPowerUpButton.h"

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
@property (nonatomic, strong) CCSprite * circle_icon_left;

@property (nonatomic, strong) CCSprite * circleMid;
@property (nonatomic, strong) CCSprite * circle_icon_center;

@property (nonatomic, strong) CCSprite * circleRight;
@property (nonatomic, strong) CCSprite * circle_icon_right;

//New Power Buttons
@property (nonatomic, strong) GuiPowerUpButton * button_top_green;

//SquareButtons
@property (nonatomic, strong) CCSprite * square_green_top;
@property (nonatomic, strong) CCSprite * square_green_bottom;
@property (nonatomic, strong) CCSprite * square_red_top;
@property (nonatomic, strong) CCSprite * square_red_bottom;
@property (nonatomic, strong) CCSprite * square_blue_top;
@property (nonatomic, strong) CCSprite * square_blue_bottom;


@property (nonatomic, strong) CCLabelTTF * coinCountLabel;
@property (nonatomic, strong) CCControlButton * yesButton;
@property (nonatomic, strong) CCControlButton * getMoreButton;
@property (nonatomic, strong) BuyCoinsMenu * buyCoinsMenu;
@property (nonatomic, strong) NSMutableArray * currentPowers;

@property (nonatomic, strong) CCLabelTTF * priceBlueBottomButton;
@property (nonatomic, strong) CCLabelTTF * priceGreenTopButton;
@property (nonatomic, strong) CCLabelTTF * priceGreenBottomButton;
@property (nonatomic, strong) CCLabelTTF * priceRedTopButton;
@property (nonatomic, strong) CCLabelTTF * priceRedBottomButton;
@property (nonatomic, strong) CCLabelTTF * priceBlueTopButton;

@property (nonatomic, strong) CCLabelTTF * powerDescription;



@end
