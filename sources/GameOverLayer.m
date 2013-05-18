//
//  GameOverLayer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/17/12.
//
//

#import "GameLayer.h"
#import "GameOverLayer.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"

@implementation GameOverLayer
@synthesize finalScoreLabel;
@synthesize finalMultiplierLabel;
@synthesize highScoreLabel;

- (void) pressedNO:(id) sender
{
    NSLog(@"pressed no!");
    
    exit(0);

}

- (void) pressedYES:(id) sender
{
    CCBAnimationManager* animationManager = self.userObject;
    NSLog(@"animationManager: %@", animationManager);
    [[GameLayer sharedGameLayer] resumeSchedulerAndActions];
    [animationManager runAnimationsForSequenceNamed:@"Pop out"];
    [[GameLayer sharedGameLayer] cleanUpPlayField];
    [[GameLayer sharedGameLayer].score setScoreValue:0];
}


//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData:(int) finalMultiplier finalScore:(int)myFinalScore
           highScore:(int) myHighScore
{
    NSLog(@"value of finalScoreLabel: %@", self.finalScoreLabel.string);
    
    [self.finalScoreLabel setString:[NSString stringWithFormat:@"%d",
                                         myFinalScore]];
    [self.finalMultiplierLabel setString:[NSString stringWithFormat:@"x%d",
                                     finalMultiplier]];
    [self.highScoreLabel setString:[NSString stringWithFormat:@"%d",
                                    myHighScore]];
}

- (void) pressedHome:(id) sender
{
    NSLog(@"pressed HOME!");

    // Load the mainMenu scene
    CCScene* mainMenuScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
    
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:mainMenuScene];
}


- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    NSLog(@"%@",name);
    if ([name compare:@"Pop out"] == NSOrderedSame) {
        self.visible = NO;
    }
//    [[GameLayer sharedGameLayer] unschedule:@selector(update:)];
//    [[CCDirector sharedDirector] pause];
}
@end
