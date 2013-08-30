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
-(void) showSubscriptionBox
{
    SubscribeAlertView *alert = [[SubscribeAlertView alloc] initWithTitle:@"Subscribe"
                                                                  message:@"Enter your email address to subscribe to our mailing list."
                                                                   apiKey:@"dac566acd8c13e49bf2170c3f29d8e6e-us7"
                                                                   listId:@"ce39e6a368"
                                                        cancelButtonTitle:@"Cancel"
                                                     subscribeButtonTitle:@"Subscribe"];
    [alert show];
    
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
