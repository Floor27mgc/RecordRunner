//
//  IAPHelper.h
//  Rotato
//
//  Created by Hin Lam on 8/19/13.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
// Add two new method declarations
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
@end
