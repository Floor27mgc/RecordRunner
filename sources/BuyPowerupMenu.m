//
//  BuyPowerupMenu
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 8/20/12.
//
//

#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "BuyPowerupMenu.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import "BuyCoinsMenu.h"
#import <GameKit/GameKit.h>
#import <Social/Social.h>

@interface BuyPowerupMenu ()

@end

@implementation BuyPowerupMenu
@synthesize coinCountLabel;
@synthesize buyCoinsMenu;


// -----------------------------------------------------------------------------------
- (void) pressedPlay:(id) sender
{
    self.isQuitting = YES;
    
    [self turnOffButtons];
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"PowerupPopOut"];
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
- (void) pressedPowerButton: (id) sender
{
    NSLog(@"pressed BUTTON!");
}


// -----------------------------------------------------------------------------------
- (void) pressedTopGreen: (id) sender
{
    NSLog(@"pressed pressedTopGreen!");
}
// -----------------------------------------------------------------------------------
- (void) pressedBottomGreen: (id) sender
{
    NSLog(@"pressed pressedBottomGreen!");
}
// -----------------------------------------------------------------------------------
- (void) pressedTopRed: (id) sender
{
    NSLog(@"pressed pressedTopRed!");
}
// -----------------------------------------------------------------------------------
- (void) pressedBottomRed: (id) sender
{
    NSLog(@"pressed pressedBottomRed!");
}
// -----------------------------------------------------------------------------------
- (void) pressedTopBlue: (id) sender
{
    NSLog(@"pressed pressedTopBlue!");
}
// -----------------------------------------------------------------------------------
- (void) pressedBottomBlue: (id) sender
{
    NSLog(@"pressed pressedBottomBlue!");
}


// -----------------------------------------------------------------------------------
//This quits the game
- (void) pressedGetMore:(id) sender
{
        NSLog(@"pressed GET MORE!");
        self.isQuitting = NO;
        
        [self turnOffButtons];
        
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"PowerupPopOut"];
        
}

// -----------------------------------------------------------------------------------
//Plays the entrance animation again. Used by the coins buy menu when switching back
- (void) openMenu
{
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"PowerupPopIn"];
}

// -----------------------------------------------------------------------------------
//Open get more menu
-(void) openBuyCoinsMenu
{
    if (buyCoinsMenu != nil)
    {
        //This sets the menu data for the final menu
        [buyCoinsMenu setMenuData: 1234];
        
        buyCoinsMenu.visible = YES;
        
        [buyCoinsMenu openMenu];
        
    } else {
        buyCoinsMenu =
        (BuyCoinsMenu *) [CCBReader nodeGraphFromFile:@"BuyCoinsMenu.ccbi"]; 
        buyCoinsMenu.position = COMMON_SCREEN_CENTER;
        
        //This sets the menu data for the final menu
        [buyCoinsMenu setMenuData: 1234];
        
        [[GameLayer sharedGameLayer] addChild:buyCoinsMenu z:11];
    }
}

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if ([name compare:@"PowerupPopOut"] == NSOrderedSame) {
        
        //Game is over, start the next round
        if (self.isQuitting)
        {
                [[GameLayer sharedGameLayer] startTheNextRound];
        }
        else
        {
            [self openBuyCoinsMenu];
        }
    }
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
