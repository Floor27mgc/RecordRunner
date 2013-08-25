//
//  RotatoIAPHelper.h
//  Rotato
//
//  Created by Hin Lam on 8/19/13.
//
//

#import "IAPHelper.h"

@interface RotatoIAPHelper : IAPHelper
+ (RotatoIAPHelper *)sharedInstance;
@property (nonatomic, strong) NSArray *productsIAP;
@end
