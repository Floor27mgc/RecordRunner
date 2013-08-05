//
//  GameOverLayer.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/17/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <GameKit/GameKit.h>
#import "CCControlButton.h"

@interface GameOverLayer : CCNode <CCBAnimationManagerDelegate,MFMailComposeViewControllerDelegate>

- (void) pressedNO:(id) sender;
- (void) pressedYES:(id) sender;
- (void) setMenuData:(int) myFinalScore;
           
- (void) pressedFeedback:(id)sender;
- (void) pressedFB:(id) sender;

@property BOOL isQuitting;
@property (nonatomic, strong) CCLabelTTF * finalScoreLabel;
@property (nonatomic, strong) CCControlButton * yesButton;

@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIViewController *emailViewController;

@property BOOL yesButtonEnabled;
@property BOOL homeButtonEnabled;
@end
