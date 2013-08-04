//
//  MainMenuSettingsBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/2/13.
//
//

#import "MainMenuSettingsBox.h"


@implementation MainMenuSettingsBox

@synthesize musicButtonLabel;
@synthesize soundButtonLabel;

int musicON = NO;
int sfxON = NO;

// -----------------------------------------------------------------------------------
- (id) init
{
    self = [super init];
    
    if (!self) return NULL;
    
    musicON = [GameInfoGlobal sharedGameInfoGlobal].isBackgroundMusicOn;
    [self setToggleText:musicON];
    
    
    sfxON = [GameInfoGlobal sharedGameInfoGlobal].isSoundEffectOn;
    [self setSoundToggleText:sfxON];
    
    return self;
    
}

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
    musicON = [GameInfoGlobal sharedGameInfoGlobal].isBackgroundMusicOn;
    [self setToggleText:musicON];
    
    
    sfxON = [GameInfoGlobal sharedGameInfoGlobal].isSoundEffectOn;
    [self setSoundToggleText:sfxON];
    

    
}

// -----------------------------------------------------------------------------------
- (void) pressedMusic: (id)sender
{
    
    NSLog(@"MUSIC %d", musicON);
    musicON = [GameInfoGlobal sharedGameInfoGlobal].isBackgroundMusicOn;
    
    [[GameInfoGlobal sharedGameInfoGlobal] setMusic: !musicON];
    [self setToggleText:[GameInfoGlobal sharedGameInfoGlobal].isBackgroundMusicOn];
    
}

// -----------------------------------------------------------------------------------
- (void) pressedSound: (id)sender
{
    
    NSLog(@"SOUND %d", sfxON);
    sfxON = [GameInfoGlobal sharedGameInfoGlobal].isSoundEffectOn;
    
    [[GameInfoGlobal sharedGameInfoGlobal] setSound: !sfxON];
    [self setSoundToggleText:[GameInfoGlobal sharedGameInfoGlobal].isSoundEffectOn];
    
}

//Switches the button.
//Pass in what you want the button to be
- (void) setToggleText: (BOOL) setToThis
{
    if (setToThis)
    {
        [self.musicButtonLabel setString:@"YES"];
    }
    else
    {
        [self.musicButtonLabel setString:@"NO"];
    }
}

//Switches the button.
//Pass in what you want the button to be
- (void) setSoundToggleText: (BOOL) setToThis
{
    if (setToThis)
    {
        [self.soundButtonLabel setString:@"YES"];
    }
    else
    {
        [self.soundButtonLabel setString:@"NO"];
    }
}

@end
