//
//  MenuBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/4/13.
//
//

#import "MenuBox.h"

@implementation MenuBox

@synthesize isOpen;
@synthesize finalScore;
@synthesize beenAdded;

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        self.isOpen = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (BOOL) isOpen:(id) sender
{
    return self.isOpen;
}

// -----------------------------------------------------------------------------------
- (void) toggleTab:(id) sender
{
    
    if(self.isOpen)
    {
        [self closeTab:self];
    }
    else{
        [self openTab:self];
    }
    
}

// -----------------------------------------------------------------------------------
- (void) openTab:(id) sender
{
    //CCBAnimationManager* animationManager = self.userObject;
    NSLog(@"Open menuBox: %@", self);
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"popIn"];
    
    [[SoundController sharedSoundController] playSoundIdx:SOUND_MENU_OPEN fromObject:self];
        
    self.isOpen = YES;
}

// -----------------------------------------------------------------------------------
- (void) closeTab:(id) sender
{
    //CCBAnimationManager* animationManager = self.userObject;
    NSLog(@"Close menuBox: %@", self);
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"popOut"];
    
    self.isOpen = NO;
}

// -----------------------------------------------------------------------------------
- (void) bounceTab: (id) sender
{
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"bounce"];
    
    self.isOpen = YES;
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
}

@end
