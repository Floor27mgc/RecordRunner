//
//  MainGameScene.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/9/13.
//
//

#import "MainGameScene.h"
#import "CCBReader.h"
#import "common.h"
#import "GameLayer.h"

@implementation MainGameScene
@synthesize score;
static MainGameScene *sharedGameScene;
+ (MainGameScene *) sharedGameLayer
{
    return sharedGameScene;
}

-(id) init
{    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        sharedGameScene = self;
    }
    return self;
}

- (void) setScore:(int) score
{
    
}

- (void) openDebugMenu:(id) sender
{
    CCNode* gameDebugLayer = [CCBReader nodeGraphFromFile:@"DebugMenuNode.ccbi"];
    gameDebugLayer.position = ccp(COMMON_SCREEN_CENTER_X,COMMON_SCREEN_CENTER_Y);
//    [[GameLayer sharedGameLayer] addChild:gameDebugLayer z:12];
    [GameLayer sharedGameLayer].isDebugMode = YES;
    [self addChild:gameDebugLayer z:12];
/*    if ([GameLayer sharedGameLayer].gameOverLayer != nil)
    {
        CCBAnimationManager* animationManager =
        [GameLayer sharedGameLayer].gameOverLayer.userObject;
        NSLog(@"animationManager: %@", animationManager);
        
        [animationManager runAnimationsForSequenceNamed:@"Pop in"];
    } else {
        CCNode* gameOverLayer = [CCBReader nodeGraphFromFile:@"GameOverLayerBox.ccbi"];
        gameOverLayer.position = COMMON_SCREEN_CENTER;
        [[GameLayer sharedGameLayer] addChild:gameOverLayer z:11];
    } */
}

@end

