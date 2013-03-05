//
//  GameModeMenu.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//
#import "cocos2d.h"
#import "CCBReader.h"
#import "GameModeMenu.h"
#import "GameInfoGlobal.h"

@implementation GameModeMenu
-(id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
    }
    return self;
} 
- (void) pressedMode1:(id)sender
{
    [GameInfoGlobal sharedGameInfoGlobal].gameMode = kGameModeNormal;
    [[CCDirector sharedDirector] pushScene:[CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"]];
}
- (void) pressedMode2:(id)sender
{
    [GameInfoGlobal sharedGameInfoGlobal].gameMode = kGameModeBouncyMusic;
    [[CCDirector sharedDirector] pushScene:[CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"]];    
}

- (void) pressedMode3:(id)sender
{
    [GameInfoGlobal sharedGameInfoGlobal].gameMode = kGameModeRotatingPlayer;
    [[CCDirector sharedDirector] pushScene:[CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"]];

}
- (void) pressedMode4:(id)sender
{
    [GameInfoGlobal sharedGameInfoGlobal].gameMode = kGameModeNormal;
    [[CCDirector sharedDirector] pushScene:[CCBReader sceneWithNodeGraphFromFile:@"MainGameScene.ccbi"]];

}
@end
