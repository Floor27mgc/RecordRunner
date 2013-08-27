//
//  BuyPowerupMenu
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 8/20/12.
//
//

#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "BuyCoinsMenu.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import "RotatoIAPHelper.h"
#import <GameKit/GameKit.h>
#import <Social/Social.h>

@interface BuyPowerupMenu ()

@end

@implementation BuyCoinsMenu
@synthesize coinCountLabel;

static BuyCoinsMenu *shareBuyCoinsMenu;

+ (BuyCoinsMenu *) shareBuyCoinsMenu
{
    return shareBuyCoinsMenu;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        shareBuyCoinsMenu = self;
    }
    return self;
}

// -----------------------------------------------------------------------------------
- (void) pressedBack:(id) sender
{    
    [self turnOffButtons];
    
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"CoinPopOut"];
}

// -----------------------------------------------------------------------------------
//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData:(int) myCoinCount
{
    
    [self.coinCountLabel setString:[NSString stringWithFormat:@"%d",
                                         1234]];
}

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
}


// -----------------------------------------------------------------------------------
//Plays the entrance animation again. Used by the coins buy menu when switching back
- (void) openMenu
{
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"CoinPopIn"];
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    //Hide the buy menu and show the game over menu
    if ([name compare:@"CoinPopOut"] == NSOrderedSame) {
        
        //Game is over, start the next round
        [[GameLayer sharedGameLayer].gameOverLayer openPowerupMenu];
        
    }

}


// -----------------------------------------------------------------------------------
- (void) pressedButton1: (id) sender
{
    NSLog(@"pressed pressedButton1!");
    NSURL *urlApp = [NSURL URLWithString:@"fb://profile/160525450781718"];
    
    //Check if the Facebook app exists on the phone.
    if ([[UIApplication sharedApplication] canOpenURL:urlApp])
    {
        //Then open it in the app
        bool rc = [[UIApplication sharedApplication] openURL:urlApp];
        
        if (rc == YES)
        {
            [GameInfoGlobal sharedGameInfoGlobal].coinsInBank += 800;
            [GameInfoGlobal sharedGameInfoGlobal].FacebookLikedAlready = YES;
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setInteger:[GameInfoGlobal sharedGameInfoGlobal].coinsInBank forKey:@"coinBank"];
            [standardUserDefaults setBool:YES forKey:@"fbLiked"];
            [standardUserDefaults synchronize];
        }
    }
}
// -----------------------------------------------------------------------------------
- (void) pressedButton2: (id) sender
{
    NSLog(@"pressed pressedButton2!");
    [[RotatoIAPHelper sharedInstance] buyProduct:[RotatoIAPHelper sharedInstance].productsIAP[2]];
}
// -----------------------------------------------------------------------------------
- (void) pressedButton3: (id) sender
{
    NSLog(@"pressed pressedButton3!");
    [[RotatoIAPHelper sharedInstance] buyProduct:[RotatoIAPHelper sharedInstance].productsIAP[1]];
}

// -----------------------------------------------------------------------------------
- (void) pressedButton4: (id) sender
{
    NSLog(@"pressed pressedButton4!");
    [[RotatoIAPHelper sharedInstance] buyProduct:[RotatoIAPHelper sharedInstance].productsIAP[3]];
}
// -----------------------------------------------------------------------------------
- (void) pressedButton5: (id) sender
{
    NSLog(@"pressed pressedButton5!");
    [[RotatoIAPHelper sharedInstance] buyProduct:[RotatoIAPHelper sharedInstance].productsIAP[0]];
}



// -----------------------------------------------------------------------------------
//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOffButtons
{
    //$$$
}

// -----------------------------------------------------------------------------------
//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOnButtons
{
    //$$$
}

@end
