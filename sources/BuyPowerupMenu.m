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
{
    int numSelectedPower;
    NSArray *descriptionArray;
/*    char *descriptionArray[] = {
        DESCRIPTION_BLANK_SPACE,
        DESCRIPTION_RECORD_SPINS_SLOWER,
        DESCRIPTION_INCREASE_STAR_SPAWN_RATE,
        DESCRIPTION_CLOSE_CALL_TIMES_2,
        DESCRIPTION_MINIMUM_MULTIPLIER_OF_3,
        DESCRIPTION_START_WITH_SHIELD,
        DESCRIPTION_DOUBLE_COINS
    };*/
}
@end

@implementation BuyPowerupMenu
@synthesize coinCountLabel;
@synthesize buyCoinsMenu;
@synthesize button_top_green;

//Base Colors for the squares
ccColor3B green_top;
ccColor3B green_bottom;
ccColor3B red_top;
ccColor3B red_bottom;
ccColor3B blue_top;
ccColor3B blue_bottom;

@synthesize priceGreenTopButton;
@synthesize priceGreenBottomButton;
@synthesize priceRedTopButton;
@synthesize priceRedBottomButton;
@synthesize priceBlueTopButton;
@synthesize priceBlueBottomButton;


//Synth the power buttons
@synthesize square_green_top;
@synthesize square_green_bottom;
@synthesize square_red_top;
@synthesize square_red_bottom;
@synthesize square_blue_top;
@synthesize square_blue_bottom;

@synthesize WarningLabel;

@synthesize powerDescription;

@synthesize circleLeft;
@synthesize circle_icon_left;

@synthesize circleMid;
@synthesize circle_icon_center;

@synthesize circleRight;
@synthesize circle_icon_right;

@synthesize currentPowers;

- (id) init
{
    if (self = [super init])
    {
        numSelectedPower = 0;
        descriptionArray = [NSArray arrayWithObjects:DESCRIPTION_BLANK_SPACE,
                            DESCRIPTION_RECORD_SPINS_SLOWER,
                            DESCRIPTION_INCREASE_STAR_SPAWN_RATE,
                            DESCRIPTION_CLOSE_CALL_TIMES_2,
                            DESCRIPTION_MINIMUM_MULTIPLIER_OF_3,
                            DESCRIPTION_START_WITH_SHIELD,
                            DESCRIPTION_DOUBLE_COINS, nil];
        return self;
    }
    return nil;
}

// -----------------------------------------------------------------------------------
- (void) pressedPlay:(id) sender
{
    self.isQuitting = YES;
    
    [self turnOffButtons];
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"PowerupPopOut"];
    [[GameInfoGlobal sharedGameInfoGlobal].powerEngine setAllPowerUpUnchoosen];
    [self removeFromPowerList:0];
    [self.circle_icon_left setTexture:[[CCTextureCache sharedTextureCache] addImage:@"blank.png"]];
    [self removeFromPowerList:1];
    [self.circle_icon_center setTexture:[[CCTextureCache sharedTextureCache] addImage:@"blank.png"]];
    [self removeFromPowerList:2];
    [self.circle_icon_right setTexture:[[CCTextureCache sharedTextureCache] addImage:@"blank.png"]];
}

// -----------------------------------------------------------------------------------
//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData:(int) myCoinCount
{
    
    int coins = [GameInfoGlobal sharedGameInfoGlobal].coinsInBank;
        
    [self.coinCountLabel setString:[NSString stringWithFormat:@"%d",
                                    coins]];
    
    [self.priceGreenTopButton setString: [NSString stringWithFormat:@"%d",5]];
    [self.priceGreenBottomButton setString: [NSString stringWithFormat:@"%d",0]];
    [self.priceRedTopButton setString: [NSString stringWithFormat:@"%d",6]];
    [self.priceRedBottomButton setString: [NSString stringWithFormat:@"%d",7]];
    [self.priceBlueTopButton setString: [NSString stringWithFormat:@"%d",8]];
    [self.priceBlueBottomButton setString: [NSString stringWithFormat:@"%d", 10]];
    
    
    [self.powerDescription setDimensions:CGSizeMake(220,65)];

    [self.powerDescription setPosition:CGPointMake(130, 252)];
    
    green_top = ccc3(103,216,197);
    green_bottom = ccc3(103,216,197);
    red_top = ccc3(222,94,101);
    red_bottom = ccc3(222,94,101);
    blue_top = ccc3(107,197,242);
    blue_bottom = ccc3(107,197,242);
    
    self.button_top_green = (GuiPowerUpButton *)[CCBReader nodeGraphFromFile:@"GuiPowerUpButton.ccbi"];
    [self.button_top_green setMenuData:RECORD_SPINS_SLOWER price:10];
    
    
    [self updateDisplay];
}


// -----------------------------------------------------------------------------------
//Called when press one of the circles at the top.
//It places blank circle where every you left off.
- (void) removeFromPowerList: (int) powerToRemove
{
    NSMutableArray * tempList = [GameInfoGlobal sharedGameInfoGlobal].powerList;
    
    [tempList replaceObjectAtIndex:powerToRemove withObject:[NSNumber numberWithInt:(int)BLANK_SPACE] ];
    
    [GameInfoGlobal sharedGameInfoGlobal].powerList = tempList;

/*    self.button_top_green = (GuiPowerUpButton *)[CCBReader nodeGraphFromFile:@"GuiPowerUpButton.ccbi"];
    [self.button_top_green setMenuData:RECORD_SPINS_SLOWER price:10]; */
    
    
    [self updateDisplay];
}

// -----------------------------------------------------------------------------------
//This is used to construct the menu items at the
//It scans through the power list and if it finds a blank space, add the new item there.
//This is so that you can fill in the list in order.
- (void) addToPowerList: (PowerUpType) newPower
{
    NSMutableArray * tempList = [GameInfoGlobal sharedGameInfoGlobal].powerList;

    int listIndex = 0;
    int insertHere = -1;
    
    for (NSNumber * pNumber in tempList) {
        PowerUpType pType = (PowerUpType)[pNumber intValue];
        
        //If you find a blank space in the tempList, add it there
        if (pType == BLANK_SPACE) {
            insertHere = listIndex;
            break;
        }
    
        listIndex ++;
    }
    
    //If you found a place to stick it, put it there
    if (insertHere >= 0)
    {
        [tempList replaceObjectAtIndex:insertHere withObject:[NSNumber numberWithInt:(int)newPower]];
    }
    
    [GameInfoGlobal sharedGameInfoGlobal].powerList = tempList;
}

// -----------------------------------------------------------------------------------
- (void) pressedPowerButton: (id) sender
{
    NSLog(@"pressed BUTTON!");
}


// -----------------------------------------------------------------------------------
//PRESSED THE CIRCLES

// -----------------------------------------------------------------------------------
//RECORD_SPINS_SLOWER
- (void) pressedTopGreen: (id) sender
{
    if ([[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:RECORD_SPINS_SLOWER]) {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:RECORD_SPINS_SLOWER];
    }
    
    [self addToPowerList:RECORD_SPINS_SLOWER];
    [self.powerDescription setString: [NSString stringWithFormat: DESCRIPTION_RECORD_SPINS_SLOWER]];
        
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
    [self.powerDescription setString: [NSString stringWithFormat: DESCRIPTION_INCREASE_STAR_SPAWN_RATE]];
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
    [self.powerDescription setString: [NSString stringWithFormat: DESCRIPTION_CLOSE_CALL_TIMES_2]];
    
    [self updateDisplay];
    
    CCNode *node = (CCNode *) sender;
    
    IS_AVAIL_REASON reason = [[GameInfoGlobal sharedGameInfoGlobal].powerEngine IsAvaiable:node.tag];
    self.WarningLabel.visible = false;
    
    switch (reason)
    {
        case IS_AVAIL_OK:
            [[GameInfoGlobal sharedGameInfoGlobal].powerEngine Purchase:node.tag];
            [self addToPowerList:node.tag];
            break;
        case IS_AVAIL_NOT_ENOUGH_MONEY:
        {
            CCBAnimationManager* animationManager = self.userObject;
            
            [animationManager runAnimationsForSequenceNamed:@"Warning"];
        }
            break;
        default:
            break;
    }
    
    [self.powerDescription setString:[descriptionArray objectAtIndex:node.tag]];
    [self updateDisplay];
    
    NSLog(@"pressed pressedTopGreen!");
}


// -----------------------------------------------------------------------------------
//PRESSED THE CIRCLES

//When you click a circle it puts a blank spot at that circle
- (void) pressedCircleLeft: (id) sender
{
    NSNumber *powerType = [GameInfoGlobal sharedGameInfoGlobal].powerList[0];
    if (powerType.integerValue != BLANK_SPACE)
    {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine unPurchase:powerType.integerValue];
        [self removeFromPowerList:0];
        [self.circle_icon_left setTexture:[[CCTextureCache sharedTextureCache] addImage:@"blank.png"]];
        [self updateDisplay];
    }
}

- (void) pressedCircleMid: (id) sender
{
    NSNumber *powerType = [GameInfoGlobal sharedGameInfoGlobal].powerList[1];
    if (powerType.integerValue != BLANK_SPACE)
    {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine unPurchase:powerType.integerValue];
        [self removeFromPowerList:1];
        [self.circle_icon_center setTexture:[[CCTextureCache sharedTextureCache] addImage:@"blank.png"]];
        [self updateDisplay];
    }
}

- (void) pressedCircleRight: (id) sender
{
    NSNumber *powerType = [GameInfoGlobal sharedGameInfoGlobal].powerList[2];
    if (powerType.integerValue != BLANK_SPACE)
    {
        [[GameInfoGlobal sharedGameInfoGlobal].powerEngine unPurchase:powerType.integerValue];
        [self removeFromPowerList:2];
        [self.circle_icon_right setTexture:[[CCTextureCache sharedTextureCache] addImage:@"blank.png"]];
        [self updateDisplay];
    }
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
    
    //Set all the circles at the top ----------------------
    //LEFT --------------
    [self.circleLeft setColor: [self setDisplayColor: (PowerUpType) [[selectedPowers objectAtIndex:0] intValue] ]];
    //Set the icon
    [self.circle_icon_left setTexture: [[CCTextureCache sharedTextureCache] addImage: [self getDisplayIcon:(PowerUpType)[[selectedPowers objectAtIndex:0] intValue] ]]] ;
    
    //Center --------------
    [self.circleMid setColor: [self setDisplayColor: (PowerUpType) [[selectedPowers objectAtIndex:1] intValue] ]];
    //Set the icon
    [self.circle_icon_center setTexture: [[CCTextureCache sharedTextureCache] addImage: [self getDisplayIcon:(PowerUpType)[[selectedPowers objectAtIndex:1] intValue] ]]] ;

    //RIGHT --------------
    [self.circleRight setColor: [self setDisplayColor: (PowerUpType) [[selectedPowers objectAtIndex:2] intValue] ]];
    //Set the icon
    [self.circle_icon_right setTexture: [[CCTextureCache sharedTextureCache] addImage: [self getDisplayIcon:(PowerUpType)[[selectedPowers objectAtIndex:2] intValue] ]]] ;
   
    int coins = [GameInfoGlobal sharedGameInfoGlobal].coinsInBank;
    
    [self.coinCountLabel setString:[NSString stringWithFormat:@"%d",
                                    coins]];
    
    //Disable the powerups below
    [self disablePowerButtons: selectedPowers];
    
}

//This is called after 
- (void) disablePowerButtons: (NSMutableArray *) thePowers
{
    
    //Reset all of them
    [self.square_green_top setColor: green_top];
    [self.square_green_bottom setColor: green_bottom];
    [self.square_red_top setColor: red_top];
    [self.square_red_bottom setColor: red_bottom];
    [self.square_blue_top setColor: blue_top];
    [self.square_blue_bottom setColor: blue_bottom];
    
    
    //Turn them off
    for (NSNumber * pNumber in thePowers) {
        PowerUpType pType = (PowerUpType)[pNumber intValue];
        
        switch (pType)
        {
            case BLANK_SPACE:
                break;
            case RECORD_SPINS_SLOWER:
                [self.square_green_top setColor: (ccColor3B){75, 75, 75}];
                break;
            case INCREASE_STAR_SPAWN_RATE:
                [self.square_green_bottom setColor: (ccColor3B){75, 75, 75}];
                break;
            case CLOSE_CALL_TIMES_2:
                [self.square_red_top setColor: (ccColor3B){75, 75, 75}];
                break;
            case MINIMUM_MULTIPLIER_OF_3:
                [self.square_red_bottom setColor: (ccColor3B){75, 75, 75}];
                break;
            case START_WITH_SHIELD:
                [self.square_blue_top setColor: (ccColor3B){75, 75, 75}];
                break;
            case DOUBLE_COINS:
                [self.square_blue_bottom setColor: (ccColor3B){75, 75, 75}];
                break;
            default:
                break;
        }
        
    }

}



// -----------------------------------------------------------------------------------
//Takes a powerup and returns the color/sprite that pertains to it
//Called by update display
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
        case DOUBLE_COINS:
            circleColor = ccc3(107,197,242);
            break;
            
        default:
            break;            
    }
        
    return circleColor;
}


// -----------------------------------------------------------------------------------
//Takes a powerup and returns the color/sprite that pertains to it
//Called by update display
- (NSString *) getDisplayIcon: (PowerUpType) thePowerup
{
    
    NSString * icon = @"blank.png";
    
    switch (thePowerup)
    {
        case BLANK_SPACE:
            icon = @"blank.png";
            break;
        case RECORD_SPINS_SLOWER:
            icon = @"gui_power_icon_slow.png";
            break;
        case INCREASE_STAR_SPAWN_RATE:
            icon = @"gui_power_icon_stars.png";
            break;
        case CLOSE_CALL_TIMES_2:
            icon = @"gui_power_icon_close_call2.png";
            break;
        case MINIMUM_MULTIPLIER_OF_3:
            icon = @"gui_power_icon_3x_min.png";
            break;
        case START_WITH_SHIELD:
            icon = @"gui_power_icon_shield.png";
            break;
        case DOUBLE_COINS:
            icon = @"gui_power_icon_coins.png";
            break;
            
        default:
            break;
    }
    
    return icon;
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
