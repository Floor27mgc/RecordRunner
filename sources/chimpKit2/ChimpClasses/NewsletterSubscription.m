//
//  NewsletterSubscription.m
//  Rotato
//
//  Created by Hin Lam on 8/24/13.
//
//
#import "SubscribeAlertView.h"
#import "CKAuthViewController.h"
#import "NewsletterSubscription.h"

@implementation NewsletterSubscription
static bool hasSubscriptionBoxShownThisRun = NO;
-(void) showSubscriptionBox
{
    if (hasSubscriptionBoxShownThisRun == NO)
    {
        SubscribeAlertView *alert = [[SubscribeAlertView alloc] initWithTitle:@"Subscribe"
                                                                      message:@"Like ROTATO? Want to know when our games go on sale? Sign up for the news letter"
                                                                       apiKey:@"dac566acd8c13e49bf2170c3f29d8e6e-us7"
                                                                       listId:@"ce39e6a368"
                                                            cancelButtonTitle:@"Cancel"
                                                         subscribeButtonTitle:@"Subscribe"];
        hasSubscriptionBoxShownThisRun = YES;
        [alert show];
    }
    
} 

- (void)ckAuthSucceededWithApiKey:(NSString *)apiKey {
    NSLog(@"Auth success - api key is: %@", apiKey);
}

- (void)ckAuthFailedWithError:(NSError *)error {
    NSLog(@"Auth failed - error is: %@", error);
}

- (void)ckAuthUserDismissedView {
    NSLog(@"User dismissed view");
}
@end
