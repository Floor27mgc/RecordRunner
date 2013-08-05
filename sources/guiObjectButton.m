//
//  GameObjectCheck.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/21/13.
//
//

#import "guiObjectButton.h"
#import "GameLayer.h"

@implementation guiObjectButton


/*
// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        self.animationManager = self.userObject;
        
    }
    
    return self;
}*/

// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
}


// -----------------------------------------------------------------------------------
- (void) showExistingCheck
{
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"AlreadyAchieved"];
}


// -----------------------------------------------------------------------------------
- (void) showNewCheck
{
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"Blip"];
    
}

// -----------------------------------------------------------------------------------
- (void) hideCheck
{
    
    CCBAnimationManager* animationManager = self.userObject;
    
    [animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
    
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
