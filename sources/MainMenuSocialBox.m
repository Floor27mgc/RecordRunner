//
//  MainMenuSocialBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/2/13.
//
//

#import "MainMenuSocialBox.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "common.h"
@implementation MainMenuSocialBox 
@synthesize emailView;
@synthesize emailViewController;

// -----------------------------------------------------------------------------------
- (void) pressedFacebook: (id)sender
{
    
    NSLog(@"open facebook");
    
    //play the animation for the reaction
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"facebookButtonReaction"];
   
}

// -----------------------------------------------------------------------------------
- (void) pressedTwitter: (id)sender
{
    
    //play the animation for the reaction
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"twitterButtonReaction"];
    
    
}

// -----------------------------------------------------------------------------------
- (void) pressedEmail: (id)sender
{
    
    //play the animation for the reaction
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"emailButtonReaction"];
    
}

// -----------------------------------------------------------------------------------
//This monitors when animations complete.
//When one is complete, then it calls the action that it should.
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    NSLog(@"MainMenuSocialBox %@",name);
    if ([name compare:@"facebookButtonReaction"] == NSOrderedSame) {
        
        
        NSURL *urlApp = [NSURL URLWithString:@"fb://profile/160525450781718"];
        
        //Check if the Facebook app exists on the phone.
        if ([[UIApplication sharedApplication] canOpenURL:urlApp])
        {
            //Then open it in the app
            [[UIApplication sharedApplication] openURL:urlApp];
        }
    }
    else if( [name compare:@"emailButtonReaction"] == NSOrderedSame)
    {
        
        NSLog(@"open email");
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Rotato feedback"];
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"contact@floor27industries.com"]];
        
        [mailViewController setMessageBody:@"Comment:\n" isHTML:NO];

        emailViewController = [[UIViewController alloc]init];
        emailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH, COMMON_SCREEN_HEIGHT)];
        emailViewController.view = emailView;
        [[[CCDirector sharedDirector] view] addSubview:emailView];
        [emailViewController presentViewController:mailViewController animated:YES completion:nil];

    
    }
    else if( [name compare:@"twitterButtonReaction"] == NSOrderedSame)
    {
        
        NSLog(@"open twitter");
               
        
        NSURL *twitterUrlApp = [NSURL URLWithString:@"twitter://Floor27Industry"];
        
        if ([[UIApplication sharedApplication] canOpenURL:twitterUrlApp])
        {
            [[UIApplication sharedApplication] openURL:twitterUrlApp];
        }

    }
}

// -----------------------------------------------------------------------------------
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [emailViewController dismissViewControllerAnimated:YES completion:nil];
    [emailView removeFromSuperview];
    emailView = nil;
    emailViewController = nil;
}

@end
