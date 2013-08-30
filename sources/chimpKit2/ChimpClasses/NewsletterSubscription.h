//
//  NewsletterSubscription.h
//  Rotato
//
//  Created by Hin Lam on 8/24/13.
//
//

#import <Foundation/Foundation.h>
#import "CKAuthViewController.h"
@interface NewsletterSubscription : NSObject <CKAuthViewControllerDelegate>
-(void) showSubscriptionBox;
@end
