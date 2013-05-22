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
@interface GameOverLayer : CCNode <CCBAnimationManagerDelegate,MFMailComposeViewControllerDelegate>
/*
@property (nonatomic, assign) GameLayer * parentGameLayer;
@property (nonatomic, assign) CCMenuItem * noButton;
@property (nonatomic, assign) CCMenuItem * yesButton;
@property (nonatomic, assign) CCMenuItem * resetButton;

+ (id)initWithScoreString:(NSString *) score
                  winSize:(CGSize) winSize
                gameLayer:(GameLayer *) gamelayer
                highScore:(bool) won
                 bankSize:(int)coinsInBank;
- (id) init;
- (void) yesTapped:(id) sender;
- (void) noTapped:(id) sender;
- (void) resetTapped:(id) sender; */
- (void) pressedNO:(id) sender;
- (void) pressedYES:(id) sender;
- (void) setMenuData:(int) finalMultiplier finalScore:(int) myFinalScore
           highScore:(int) myHighScore;
- (void) pressedFeedback:(id)sender;

@property (nonatomic, strong) CCLabelTTF * finalScoreLabel;
@property (nonatomic, strong) CCLabelTTF * finalMultiplierLabel;
@property (nonatomic, strong) CCLabelTTF * highScoreLabel;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIViewController *emailViewController;
@end
