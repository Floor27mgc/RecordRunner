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

@interface MainMenuSocialBox : MenuBox <MFMailComposeViewControllerDelegate>
{
    
}
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIViewController *emailViewController;
@end
