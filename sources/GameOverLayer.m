//
//  GameOverLayer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/17/12.
//
//

#import "GameLayer.h"
#import "GameInfoGlobal.h"
#import "GameOverLayer.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import <GameKit/GameKit.h>
#import <Social/Social.h>

@interface GameOverLayer ()
-(UIImage*) screenshotWithStartNode:(CCNode*)startNode;
@end

@implementation GameOverLayer
@synthesize finalScoreLabel;
@synthesize emailView;
@synthesize emailViewController;
@synthesize isQuitting;
@synthesize rankLabel;
@synthesize yesButton;
@synthesize yesButtonEnabled;
@synthesize homeButtonEnabled;

@synthesize closeMissionButtonEnabled;
@synthesize openMissionButtonEnabled;

@synthesize goal1;
@synthesize goal2;
@synthesize goal3;



// -----------------------------------------------------------------------------------
- (void) pressedNO:(id) sender
{
    NSLog(@"pressed no!");
    
    exit(0);

}

// -----------------------------------------------------------------------------------
- (void) pressedYES:(id) sender
{
    if (yesButtonEnabled)
    {
        self.isQuitting = NO;
        
        [self turnOffButtons];
        
        
        CCBAnimationManager* animationManager = self.userObject;
        
        
        [animationManager runAnimationsForSequenceNamed:@"Pop out"];
        
    }
}

// -----------------------------------------------------------------------------------
//This method is used to set the labels in the Game Over Menu.
//For example, before G.O. Menu is shown, call this method to set those two values
- (void) setMenuData:(int) myFinalScore
           rankLevel:(int) rankScore

{
    
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed++;
    [[GameInfoGlobal sharedGameInfoGlobal] logLifeTimeAchievements];
    
    
    
    // reset the per-life statistics
    [[GameInfoGlobal sharedGameInfoGlobal] resetPerLifeStatistics];
    
    // reset the multiplier
    [[GameLayer sharedGameLayer].multiplier reset];
    
    [self.finalScoreLabel setString:[NSString stringWithFormat:@"%d",
                                         myFinalScore]];
    
    [self.rankLabel setString:[NSString stringWithFormat:@"%d",
                                     rankScore]];
    
    
    GKScore *myScoreValue = [[GKScore alloc] initWithCategory:@"RotatoLeaderBoard"];
    myScoreValue.value = myFinalScore;
    
    [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
        if(error != nil){
            NSLog(@"Score Submission Failed");
        } else {
            NSLog(@"Score Submitted");
        }
        
    }];
}

// -----------------------------------------------------------------------------------
//This quits the game
- (void) pressedMissions:(id) sender
{
    if (openMissionButtonEnabled)
    {
        NSLog(@"pressed missions!");
        
        [self turnOffButtons];
        
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"MissionIn"];

    }
}

// -----------------------------------------------------------------------------------
//This quits the game
- (void) pressedCloseMission:(id) sender
{
    if (closeMissionButtonEnabled)
    {
        NSLog(@"pressed out missions!");
        
        [self turnOffButtons];
        
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"MissionOut"];
        
    }
}


// -----------------------------------------------------------------------------------
//This quits the game
- (void) pressedHome:(id) sender
{
    if (homeButtonEnabled)
    {
        NSLog(@"pressed HOME!");
        self.isQuitting = YES;
        
        [self turnOffButtons];
        
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"Pop out"];
        
    }
}


// -----------------------------------------------------------------------------------
- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    
    yesButtonEnabled = NO;
    homeButtonEnabled = NO;
    
}

// -----------------------------------------------------------------------------------
- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if ([name compare:@"Pop out"] == NSOrderedSame) {
        
        //If the player pressed quit then you need to go to the main menu
        if (isQuitting)
        {
            NSLog(@"POST ANIMATION: RUN THE QUIT!");
            // Load the mainMenu scene
            CCScene* mainMenuScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
            
            // Go to the game scene
            [[CCDirector sharedDirector] replaceScene:mainMenuScene];
        }        
        self.visible = NO;
        self.yesButtonEnabled = true;
        self.homeButtonEnabled = true;
        
        //Game is over, start the next round
        [[GameLayer sharedGameLayer] startTheNextRound];
    }
    else if ([name compare:@"Pop in"] == NSOrderedSame)
    {
        //Turn on the buttons after the menu finishes coming in.
        [self turnOnButtons];
    }
    else if ([name compare:@"MissionIn"] == NSOrderedSame)
    {
        //Turn on the buttons after the menu finishes coming in.
        [self turnOnButtons];
    }
    else if ([name compare:@"MissionOut"] == NSOrderedSame)
    {
        //Turn on the buttons after the menu finishes coming in.
        [self turnOnButtons];
    }
}

// -----------------------------------------------------------------------------------
//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOffButtons
{
    
    //$$TODO: Figure out how to turn off the play button. It can be pressed repeatedly.
    yesButtonEnabled = NO;
    homeButtonEnabled = NO;
    
    closeMissionButtonEnabled = NO;
    openMissionButtonEnabled = NO;
    
}

// -----------------------------------------------------------------------------------
//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOnButtons
{
    
    //TODO: Figure out how to turn off the play button. It can be pressed repeatedly.
    yesButtonEnabled = YES;
    homeButtonEnabled = YES;
    
    
    closeMissionButtonEnabled = YES;
    openMissionButtonEnabled = YES;
}

// -----------------------------------------------------------------------------------
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [emailViewController dismissViewControllerAnimated:YES completion:nil];
    [emailView removeFromSuperview];
    emailView = nil;
    emailViewController = nil;
    
}

// -----------------------------------------------------------------------------------
-(void) pressedFB:(id)sender
{
    // Make sure this phone is facebook capable
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] == FALSE)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Facebook login not setup" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    // Do a screenshot for later posting
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    CCNode *n = [scene.children objectAtIndex:0];
    UIImage *image = [self screenshotWithStartNode:n];
    
    // Setup facebook sheet for user to input facebook content
    SLComposeViewController *faceBookSheet  = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [faceBookSheet setInitialText:[NSString stringWithFormat:@"Check out my Rotato high score: %d\n Download from: ",
                                   [[GameLayer sharedGameLayer].score getScore]]];
    [faceBookSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/rotato/id624995751?ls=1&mt=8"]];
    [faceBookSheet addImage:image];

    // Create a dummy view controller to present the facebook sheet
    UIViewController *dummyViewController = [[UIViewController alloc]init];
    UIView *dummyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_WIDTH, COMMON_SCREEN_HEIGHT)];
    dummyViewController.view = dummyView;
    [[[CCDirector sharedDirector] view] addSubview:dummyView];
    [dummyViewController presentViewController:faceBookSheet animated:TRUE completion:nil];

    // When done, dismiss the sheet.
    [faceBookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        [dummyViewController dismissViewControllerAnimated:TRUE completion:nil];
    }];
    
}

// -----------------------------------------------------------------------------------
-(UIImage*) screenshotWithStartNode:(CCNode*)startNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImage];
}

@end
