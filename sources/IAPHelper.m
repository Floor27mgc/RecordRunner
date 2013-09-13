//
//  IAPHelper.m
//  Rotato
//
//  Created by Hin Lam on 8/19/13.
//
//

// 1
#import "IAPHelper.h"
#import "GameInfoGlobal.h"
#import "BuyCoinsMenu.h"
#import "GameInfoGlobal.h"
#import "SoundController.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    // 3
    SKProductsRequest * _productsRequest;
    // 4
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    [GameInfoGlobal sharedGameInfoGlobal].isIAPProductListLoaded = YES;
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    [[BuyCoinsMenu shareBuyCoinsMenu] pressedBack:self];
    
    //[[BuyCoinsMenu shareBuyCoinsMenu] pressedBack:self];
    [[BuyCoinsMenu shareBuyCoinsMenu].coinCountLabel setString:[NSString stringWithFormat:@"%d",[GameInfoGlobal sharedGameInfoGlobal].coinsInBank]];
    
    CCBAnimationManager* animationManager = [BuyCoinsMenu shareBuyCoinsMenu].userObject;
    [animationManager runAnimationsForSequenceNamed:@"coinLabelPop"];
    [[SoundController sharedSoundController] playSoundIdx:SOUND_MENU_COIN_INCREASE
                                               fromObject:[BuyCoinsMenu shareBuyCoinsMenu]];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"In App purchase error"
                                                       message:transaction.error.localizedDescription
                                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// Add new method
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [_purchasedProductIdentifiers addObject:productIdentifier];
    
    if ([productIdentifier compare:@"coins.7000"] == NSOrderedSame)
    {
        NSLog (@"Adding 7000 coins into your coin bank");        
        [GameInfoGlobal sharedGameInfoGlobal].coinsInBank += 7000;

    }

    if ([productIdentifier compare:@"coins.35000"] == NSOrderedSame)
    {
        NSLog (@"Adding 35000 coins into your coin bank");
        [GameInfoGlobal sharedGameInfoGlobal].coinsInBank += 35000;
        
    }
    
    if ([productIdentifier compare:@"coins.130000"] == NSOrderedSame)
    {
        NSLog (@"Adding 130000 coins into your coin bank");
        [GameInfoGlobal sharedGameInfoGlobal].coinsInBank += 130000;
        
    }
    
    if ([productIdentifier compare:@"coins.250000"] == NSOrderedSame)
    {
        NSLog (@"Adding 250000 coins into your coin bank");
        [GameInfoGlobal sharedGameInfoGlobal].coinsInBank += 250000;
        
    }

    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:[GameInfoGlobal sharedGameInfoGlobal].coinsInBank forKey:@"coinBank"];
    [standardUserDefaults synchronize];
    
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    if ([GameInfoGlobal sharedGameInfoGlobal].isIAPProductListLoaded == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"In app purchase error"
                                                       message:@"In app purchase content not loaded.  Please check your phone/WIFI connection"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
        //[[CCDirector sharedDirector].view addSubview:alert];
        [alert show];
    }
    else{
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}
@end