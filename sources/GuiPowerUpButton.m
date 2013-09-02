//
//  GameObjectCheck.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 9/1/13.
//
//

#import "GuiPowerUpButton.h"
#import "GameLayer.h"

@implementation GuiPowerUpButton

@synthesize buttonPowerUpType;
@synthesize isEnabled;
@synthesize costOfIt;

//Default stuff
@synthesize baseIconPath;
@synthesize squareColor;

@synthesize baseColor;

@synthesize priceLabel;
@synthesize iconImage;

@synthesize animationManager;


// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        self.animationManager = self.userObject;
    
    }
    return self;
}

- (void) setMenuData: (PowerUpType) powerUp
               price: (int) costOfPowerUp
{
        isEnabled = YES;
        
        costOfIt = costOfPowerUp;
        [self.priceLabel setString: [NSString stringWithFormat:@"%d", costOfPowerUp]];
        
        
        buttonPowerUpType = powerUp;
        
        switch (buttonPowerUpType)
        {
            case BLANK_SPACE:
                self.baseColor = ccc3(75,75,75);
                baseIconPath = @"blank.png";
                break;
            case RECORD_SPINS_SLOWER:
                self.baseColor = ccc3(103,216,197);
                baseIconPath = @"gui_power_icon_slow.png";
                break;
            case INCREASE_STAR_SPAWN_RATE:
                self.baseColor = ccc3(103,216,197);
                baseIconPath = @"gui_power_icon_stars.png";
                break;
            case CLOSE_CALL_TIMES_2:
                self.baseColor = ccc3(222,94,101);
                baseIconPath = @"gui_power_icon_close_call2.png";
                break;
            case MINIMUM_MULTIPLIER_OF_3:
                self.baseColor = ccc3(222,94,101);
                baseIconPath = @"gui_power_icon_3x_min.png";
                break;
            case START_WITH_SHIELD:
                self.baseColor = ccc3(107,197,242);
                baseIconPath = @"gui_power_icon_shield.png";
                break;
            case DOUBLE_COINS:
                self.baseColor = ccc3(107,197,242);
                baseIconPath = @"gui_power_icon_coins.png";
                break;
                
            default:
                break;
        }
    
    
  //  [self.squareColor setColor: self.baseColor];
    [self.squareColor setColor: ccWHITE ];
    
    [self.iconImage setTexture:[[CCTextureCache sharedTextureCache] addImage:self.baseIconPath]];
}
    


// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}



// -----------------------------------------------------------------------------------
- (void) pressedButton: (id) sender
{
    NSLog(@"pressed button");
    
}


// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    //After all the existing are animated. Here are the ones that were not.
    if ([name compare:@"Blip"] == NSOrderedSame) {
    
    }//Go through and finish animating all the ones that were done. This is first
    else if ([name compare:@"AlreadyAchieved"] == NSOrderedSame)
    {
        
    }
}



@end
