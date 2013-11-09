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
#import "BuyPowerupMenu.h"

@interface GameOverLayer ()
-(UIImage*) screenshotWithStartNode:(CCNode*)startNode;
@end

@implementation GameOverLayer

@synthesize powerUpMenu;

@synthesize finalScoreLabel;
@synthesize highScoreLabel;

@synthesize finalLapsLabel;
@synthesize finalLapsRecordLabel;
@synthesize coinsLabel;

@synthesize emailView;
@synthesize emailViewController;
@synthesize isQuitting;
@synthesize yesButton;

@synthesize scoreHighBanner;
@synthesize scoreHighBannerText;

@synthesize lapsHighBanner;
@synthesize lapsHighBannerText;

@synthesize facebookButton;
@synthesize shareItLabel;

@synthesize yesButtonEnabled;
@synthesize homeButtonEnabled;
@synthesize facebookButtonEnabled;

@synthesize top3ScoresOfFriends;

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
- (void) setMenuData:(int) myFinalScore rotations:(int)myFinalRotations gotHigh:(BOOL) highScore
gotMaxRotations: (BOOL)mostRotations
{
    int highScorePoints = [GameLayer sharedGameLayer].highScore.getScore;
    
    int highRotations = [GameInfoGlobal sharedGameInfoGlobal].maxNumRevolutionsInALife;
    
    //Hide the banner if you didnt get a high score = 0, 255 = show it.
    GLubyte shouldShowHighScoreBanner = highScore ? 255 : 0;
    GLubyte shouldShowHighRotationBanner = mostRotations ? 255 : 0;
    
    
    //Turn off the banner because you didnt get a high score.
    [self.scoreHighBanner setOpacity: shouldShowHighScoreBanner];
    [self.scoreHighBannerText setOpacity: shouldShowHighScoreBanner];
    
    
    //Turn off Laps banner
    [self.lapsHighBanner setOpacity:(GLubyte)shouldShowHighRotationBanner];
    [self.lapsHighBannerText setOpacity:(GLubyte)shouldShowHighRotationBanner];
    
    
    //Turn off/on share button
    //Turn it on if goe either max rotations or max score
    self.facebookButtonEnabled = highScore;
    [self.facebookButton setOpacity: fmax(shouldShowHighScoreBanner, shouldShowHighRotationBanner) ];
    [self.shareItLabel setOpacity: fmax(shouldShowHighScoreBanner, shouldShowHighRotationBanner) ];
    
    
    [GameInfoGlobal sharedGameInfoGlobal].lifetimeRoundsPlayed++;
    [[GameInfoGlobal sharedGameInfoGlobal] logLifeTimeAchievements];
    
    
    // reset the multiplier
    //[[GameLayer sharedGameLayer].multiplier reset];
    
    // reset the power ups
    [[GameInfoGlobal sharedGameInfoGlobal].powerEngine ResetPowerUps];
        
    [self.finalScoreLabel setString:[NSString stringWithFormat:@"%d",
                                         myFinalScore]];
    
    
    //set the highScore label
    [self.highScoreLabel setString:[NSString stringWithFormat:@"%d",
                                     highScorePoints]];

    
    //Set the rotations
    [self.finalLapsLabel setString:[NSString stringWithFormat:@"%d",
                                     myFinalRotations]];
    
    
    //Set the maxrotations
    [self.finalLapsRecordLabel setString:[NSString stringWithFormat:@"%d",
                                    highRotations]];
    
    //Set the coins label:
    
    [self.coinsLabel setString:[NSString stringWithFormat:@"%d",
                                          [GameInfoGlobal sharedGameInfoGlobal].numCoinsThisLife]];
    
    
    // reset the per-life statistics
    [[GameInfoGlobal sharedGameInfoGlobal] resetPerLifeStatistics];
    

    
    
    
    GKScore *myScoreValue = [[GKScore alloc] initWithCategory:@"RotatoLeaderBoard"];
    myScoreValue.value = myFinalScore;
    
    [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
        if(error != nil){
            NSLog(@"Score Submission Failed");
        } else {
            NSLog(@"Score Submitted");
        }
        
    }];
    
    // set up data structure for friends' score list
    top3ScoresOfFriends =
        [[NSMutableArray alloc] initWithCapacity:NUM_FRIENDS_SCORES_TO_LOAD];
    
    // load top 3 scores of friends who play this app
    [self LoadTopScoresOfMyFriends];
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
    
    facebookButtonEnabled = NO;
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
        self.yesButtonEnabled = YES;
        self.homeButtonEnabled =YES;
        
        //Game is over, start the next round
        //[[GameLayer sharedGameLayer] startTheNextRound];
        [self openPowerupMenu];
    }
    else if ([name compare:@"Pop in"] == NSOrderedSame)
    {
        //Turn on the buttons after the menu finishes coming in.
        [self turnOnButtons];
    }
}

// -----------------------------------------------------------------------------------
//This loads the pick powerup screen.
-(void) openPowerupMenu
{
    if (powerUpMenu != nil)
    {
        //This sets the menu data for the final menu
        [powerUpMenu setMenuData: 7890];
        
        powerUpMenu.visible = YES;

        [powerUpMenu openMenu];
        
    } else {
        powerUpMenu =
        (BuyPowerupMenu *) [CCBReader nodeGraphFromFile:@"BuyPowerupMenu.ccbi"];
        powerUpMenu.position = COMMON_SCREEN_CENTER;
        
        //This sets the menu data for the final menu
        [powerUpMenu setMenuData: 7890];
        
        [[GameLayer sharedGameLayer] addChild:powerUpMenu z:11];
    }
}


// -----------------------------------------------------------------------------------
//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOffButtons
{
    yesButtonEnabled = NO;
    homeButtonEnabled = NO;
    facebookButtonEnabled = NO;
}

// -----------------------------------------------------------------------------------
//Buttons can accept continuing input after they have been pushed. This will prevent them from being pushed again
- (void) turnOnButtons
{
    
    //TODO: Figure out how to turn off the play button. It can be pressed repeatedly.
    yesButtonEnabled = YES;
    homeButtonEnabled = YES;
    
    //facebookButtonEnabled is not here because we don't turn it on here, only if have high score.
    
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
    
    if (facebookButtonEnabled)
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

// -----------------------------------------------------------------------------------
- (void) LoadTopScoresOfMyFriends
{
    GKLeaderboard *allScoresEver = [[GKLeaderboard alloc] init];
    allScoresEver.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    allScoresEver.range = NSMakeRange(1, NUM_FRIENDS_SCORES_TO_LOAD);
    allScoresEver.category = nil;
    
    NSMutableArray * playerIDs = [[NSMutableArray alloc] init];
    
    [allScoresEver loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        
        // filter out distinct players, favouring scores from our leaderboard
        if (error != nil) {
            NSLog(@"Error loading friends' top scores from GameCenter");
        }
        
        // load the score data
        if (scores != nil) {
            for(int i = 0; i < [scores count] && i < NUM_FRIENDS_SCORES_TO_LOAD; i++) {
                
                GKScore * score = (GKScore *)[scores objectAtIndex:i];
                [top3ScoresOfFriends addObject:score];
                [GameInfoGlobal sharedGameInfoGlobal].topFriendsScores.friendScores[i].score =
                    score.value;
                
                
                [playerIDs addObject:score.playerID];
            }
            
            // load the player names from the Player IDs
            [self LoadPlayerNamesFromIds:playerIDs];
        }
        
    }];
    
    // log names (for testing)
    for (int i = 0; i < NUM_FRIENDS_SCORES_TO_LOAD; ++i) {
        NSLog(@"Friend %s -- score %d",
              [GameInfoGlobal sharedGameInfoGlobal].topFriendsScores.friendScores[i].name,
              [GameInfoGlobal sharedGameInfoGlobal].topFriendsScores.friendScores[i].score);
    }
}

// -----------------------------------------------------------------------------------
- (void) LoadPlayerNamesFromIds:(NSMutableArray *)ids
{
    [GKPlayer loadPlayersForIdentifiers:ids withCompletionHandler:^(NSArray *players, NSError *error) {
        int i = 0;
        for (GKPlayer * player in players) {

            //get the aliases
            NSString * name = player.displayName;
            
            // don't add yourself
            if (![name isEqualToString:@"Me"]) {
                NSLog(@"Found player %@", name);
                [name getCString:
                 [GameInfoGlobal sharedGameInfoGlobal].topFriendsScores.friendScores[i].name
                       maxLength:MAX_NAME_LENGTH encoding:NSASCIIStringEncoding];
                ++i;
            } else {
                NSLog(@"Found me!");
            }
        }
    }];
}

@end
