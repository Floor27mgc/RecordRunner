//
//  RotatoIAPHelper.m
//  Rotato
//
//  Created by Hin Lam on 8/19/13.
//
//

#import "RotatoIAPHelper.h"

@implementation RotatoIAPHelper
@synthesize productsIAP;
+ (RotatoIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RotatoIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"coins.500",
                                      @"coins.2700",
                                      @"coins.5200",
                                      @"coins.17000",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end
