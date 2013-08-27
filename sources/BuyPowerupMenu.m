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


@synthesize circleLeft;
@synthesize circleMid;
@synthesize circleRight;

@synthesize currentPowers;


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
    
    int coins = [GameInfoGlobal sharedGameInfoGlobal].coinsInBank;
    
    [self.coinCountLabel setString:[NSString stringWithFormat:@"%d",
                                         coins]];
}

// -----------------------------------------------------------------------------------
//This is used to construct the menu items at the
//It scans through the power list and if it finds a blank space, add the new item there.
//This is so that you can fill in the list in order.
- (void) addToPowerList: (PowerUpType) newPower
{
    NSMutableArray * globalPowerList = [GameInfoGlobal sharedGameInfoGlobal].powerList;
    
    for (id __strong aPower in globalPowerList)
    {
        if ((PowerUpType) aPower == BLANK_SPACE)
        {
            aPower = [NSNumber numberWithInt: newPower];
        }
    }
    
    [GameInfoGlobal sharedGameInfoGlobal].powerList = globalPowerList;
    
}

// -----------------------------------------------------------------------------------
- (void) pressedPowerButton: (id) sender
{
    NSLog(@"pressed BUTTON!");
}

// -----------------------------------------------------------------------------------
//RECORD_SPINS_SLOWER

- (void) pressedTopGreen: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:RECORD_SPINS_SLOWER]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:RECORD_SPINS_SLOWER];
    }
    
    [self addToPowerList:RECORD_SPINS_SLOWER];
    
    [self updateDisplay];
    
    NSLog(@"pressed pressedTopGreen!");
}
// -----------------------------------------------------------------------------------
- (void) pressedBottomGreen: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:INCREASE_STAR_SPAWN_RATE]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:INCREASE_STAR_SPAWN_RATE];
    }
    [self addToPowerList:INCREASE_STAR_SPAWN_RATE];

    [self updateDisplay];
    
    NSLog(@"pressed pressedBottomGreen!");
}
// -----------------------------------------------------------------------------------
- (void) pressedTopRed: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:CLOSE_CALL_TIMES_2]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:CLOSE_CALL_TIMES_2];
    }
    
    [self addToPowerList:CLOSE_CALL_TIMES_2];
    
    [self updateDisplay];
    
    NSLog(@"pressed pressedTopRed!");
}
// -----------------------------------------------------------------------------------
- (void) pressedBottomRed: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:MINIMUM_MULTIPLIER_OF_3]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:MINIMUM_MULTIPLIER_OF_3];
    }
    
    [self addToPowerList:MINIMUM_MULTIPLIER_OF_3];
    
    [self updateDisplay];
    
    NSLog(@"pressed pressedBottomRed!");
}
// -----------------------------------------------------------------------------------
- (void) pressedTopBlue: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:START_WITH_SHIELD]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:START_WITH_SHIELD];
    }
    
    [self addToPowerList:START_WITH_SHIELD];
    
    [self updateDisplay];
    
    NSLog(@"pressed pressedTopBlue!");
}
// -----------------------------------------------------------------------------------
- (void) pressedBottomBlue: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:INCREASE_MULTIPLIER_COOLDOWN_BY_3]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:INCREASE_MULTIPLIER_COOLDOWN_BY_3];
    }
    
    [self addToPowerList:INCREASE_MULTIPLIER_COOLDOWN_BY_3];
    
    [self updateDisplay];
    
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
//Used after you buy something or cancel something, it redraws the coin amount
//SelectedPowers are all the itmes that should appear in the circles.
- (void) updateDisplay
{
    
    NSMutableArray * selectedPowers = [GameInfoGlobal sharedGameInfoGlobal].powerList;
    
    [self.circleLeft setColor: [self setDisplayColor:(PowerUpType)[selectedPowers objectAtIndex:0]]];
    [self.circleMid setColor: [self setDisplayColor:(PowerUpType)[selectedPowers objectAtIndex:1]]];
    [self.circleRight setColor: [self setDisplayColor:(PowerUpType)[selectedPowers objectAtIndex:2]]];
    
    int coins = [GameInfoGlobal sharedGameInfoGlobal].coinsInBank;
    
    [self.coinCountLabel setString:[NSString stringWithFormat:@"%d",
                                    coins]];
}


// -----------------------------------------------------------------------------------
//Takes a powerup and returns the color/sprite that pertains to it
- (ccColor3B) setDisplayColor: (PowerUpType) thePowerup
{
    
    ccColor3B circleColor = ccWHITE;
   
    switch (thePowerup)
    {
        case BLANK_SPACE:
            circleColor = ccc3(75,75,75);
            break;
        case RECORD_SPINS_SLOWER:
            circleColor = ccc3(103,216,197);
            break;
        case INCREASE_STAR_SPAWN_RATE:
            circleColor = ccc3(103,216,197);
            break;
        case CLOSE_CALL_TIMES_2:
            circleColor = ccc3(222,94,101);
            break;
        case MINIMUM_MULTIPLIER_OF_3:
            circleColor = ccc3(222,94,101);
            break;
        case START_WITH_SHIELD:
            circleColor = ccc3(107,197,242);
            break;
        case INCREASE_MULTIPLIER_COOLDOWN_BY_3:
            circleColor = ccc3(107,197,242);
            break;
            
        default:
            break;            
    }
        
    return circleColor;
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
