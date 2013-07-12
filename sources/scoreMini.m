//
//  scoreMini.m
//  RecordRunnerARC
//
//  Created by Chris Z on 7/5/13.
//
//

#import "scoreMini.h"
#import "GameLayer.h"

@implementation scoreMini

@synthesize scoreLabel;
@synthesize animationManager;
@synthesize scoreValue;

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        self.animationManager = self.userObject;

    }
        
    return self;
}


- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}


// -----------------------------------------------------------------------------------
- (void) prepare
{
    self.animationManager = self.userObject;
    scoreLabel.color = ccWHITE;
    
}


// -----------------------------------------------------------------------------------
- (int) getScore
{
    return scoreValue;
}

// -----------------------------------------------------------------------------------
- (void) setScoreText: (NSString *) newScore
{
    
    [self.scoreLabel setString:[NSString stringWithFormat:@"%@",
                                     newScore]];
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
   
}

- (void) resetObject
{
    [super resetObject];
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    [self recycleObjectWithUsedPool:[GameLayer sharedGameLayer].scoreUsedPool                  freePool:[GameLayer sharedGameLayer].scoreFreePool];
}

@end
