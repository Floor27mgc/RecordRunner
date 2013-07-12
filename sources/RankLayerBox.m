//
//  RankLayerBox.m
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/6/13.
//
//

#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "RankLayerBox.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import <GameKit/GameKit.h>

@implementation RankLayerBox
@synthesize isQuitting;

@synthesize rankLabel;
@synthesize goal1;
@synthesize goal2;
@synthesize goal3;

//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData: (NSMutableArray *) rankRequirements currentRank: (int) ranklevel;
{
    
    NSLog(@"Rank label: %@", self.rankLabel.string);
    [self.rankLabel setString:[NSString stringWithFormat:@"%d",
                               ranklevel]];
    
    /*
     [self.goal1 setString:[NSString stringWithFormat:@"%d",
     [rankRequirements objectAtIndex: 0]]];
     
     [self.goal2 setString:[NSString stringWithFormat:@"%d",
     ranklevel]];
     
     [self.goal3 setString:[NSString stringWithFormat:@"%d",
     ranklevel]];
     */
    NSLog(@"Requirements: %@", rankRequirements);
}


- (void) pressedYES:(id) sender
{
    self.isQuitting = YES;
    
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"Pop out"];
    
}

- (void) didLoadFromCCB
{
    
    NSLog(@"Rank Layer Box DidLoad from ccb:");
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    NSLog(@"%@",name);
    
    if ([name compare:@"Pop out"] == NSOrderedSame) { 
        
        GameOverLayer * gameOverLayer =
        (GameOverLayer *) [CCBReader nodeGraphFromFile:@"GameOverLayerBox.ccbi"];
        gameOverLayer.position = COMMON_SCREEN_CENTER;
        
        //This sets the menu data for the final menu
        [gameOverLayer setMenuData:
                         [[GameLayer sharedGameLayer].score getScore]
                         rankLevel: [GameLayer sharedGameLayer].achievementContainer.currentRank];
        
        
        [[GameLayer sharedGameLayer] addChild:gameOverLayer z:11];
        
    }
    
    
    
}
@end
