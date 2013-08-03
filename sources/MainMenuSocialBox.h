//
//  MainMenuSocialBox.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/2/13.
//
//

#import "CCLayer.h"


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuBox.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "CCControlButton.h"

@interface MainMenuSocialBox : MenuBox <CCBAnimationManagerDelegate,MFMailComposeViewControllerDelegate>
{
    
}

- (void) pressedFacebook: (id)sender;
- (void) pressedTwitter: (id)sender;
- (void) pressedEmail: (id)sender;


@property (nonatomic, strong) CCControlButton * emailButton;
@property (nonatomic, strong) CCControlButton * twitterButton;
@property (nonatomic, strong) CCControlButton * facebookButton;


@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIViewController *emailViewController;
@end
