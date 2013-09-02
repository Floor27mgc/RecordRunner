//
//  GameObjectCheck.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/21/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "PowerUp.h"


@interface GuiPowerUpButton : CCNode <CCBAnimationManagerDelegate>


- (void) setMenuData:(PowerUpType ) powerUp
                   price: (int) costOfPowerUp;

- (void) pressedButton: (id) sender;

@property (nonatomic) CCBAnimationManager * animationManager;

@property PowerUpType buttonPowerUpType;
@property BOOL isEnabled;
@property ccColor3B baseColor;
@property (nonatomic, strong) NSString * baseIconPath;
@property int costOfIt;

@property (nonatomic, strong) CCLabelTTF * priceLabel;
@property (nonatomic, strong) CCSprite * iconImage;
@property (nonatomic, strong) CCSprite * squareColor;


@end



