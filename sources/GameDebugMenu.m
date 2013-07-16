//
//  GameDebugMenu.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/12/13.
//
//DebugMenu
#import "GameDebugMenu.h"
#import "MainGameScene.h"
#import "GameInfoGlobal.h"
#import "GameLayer.h"
@implementation GameDebugMenu
@synthesize debugOptionMenu;
@synthesize gameModeOptionMenu;
@synthesize optionToTweakIdx;
@synthesize valueLabel;

// -----------------------------------------------------------------------------------
- (void) pressedExit:(id) sender
{
    [GameLayer sharedGameLayer].isDebugMode = NO;
    [[GameLayer sharedGameLayer] cleanUpPlayField];
    [[GameLayer sharedGameLayer] removeChild:self];
}

// -----------------------------------------------------------------------------------
- (void) pressedGameMode:(id) sender
{
    CCMenuItemImage *selectedItem = (CCMenuItemImage *) sender;
    CCNode *child;
    CCMenuItem *currentItem;
    
    CCARRAY_FOREACH(selectedItem.parent.children, child)
    {
        currentItem = (CCMenuItem *) child;
        [currentItem unselected];
    }
    
    currentItem = (CCMenuItem *) [selectedItem.parent getChildByTag:selectedItem.tag];
    [currentItem selected];

    [self resetToDefaultGameMode];
    
    switch (selectedItem.tag) {
        case 1: [GameLayer sharedGameLayer].player.gameObjectAngularVelocity =
            kDefaultGameObjectAngularVelocityInDegree;
            break;
        case 2:
            break;
        default:
            NSLog(@"[ERROR] invalid optionToTweakIdx[%d]",optionToTweakIdx);
            break;
    }
    [[GameLayer sharedGameLayer] cleanUpPlayField];
}

// -----------------------------------------------------------------------------------
-(void) resetToDefaultGameMode
{
    [GameLayer sharedGameLayer].player.gameObjectAngularVelocity = 0;
    [GameLayer sharedGameLayer].player.angleRotated = 0;
    [[GameLayer sharedGameLayer].player moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_RECORD_CENTER,
                                             [GameLayer sharedGameLayer].player.radius,
                                             [GameLayer sharedGameLayer].player.angleRotated)];
}

// -----------------------------------------------------------------------------------
- (void) pressedDebugOption:(id) sender
{
    CCMenuItemImage *selectedItem = (CCMenuItemImage *) sender;
    CCNode *child;
    CCMenuItem *currentItem;
    
    CCARRAY_FOREACH(self.debugOptionMenu.children, child)
    {
        currentItem = (CCMenuItem *) child;
        [currentItem unselected];
    }
    
    currentItem = (CCMenuItem *) [self.debugOptionMenu getChildByTag:selectedItem.tag];
    [currentItem selected];
    optionToTweakIdx = selectedItem.tag;
    
    switch (optionToTweakIdx) {
        case 1:
            [valueLabel setString:[NSString stringWithFormat:@"%2.1f",
                                   [[GameLayer sharedGameLayer] getGameAngularVelocityInDegree]]];
            break;
        case 2:
            [valueLabel setString:[NSString stringWithFormat:@"%d",[[GameLayer sharedGameLayer] getBombSpawnRate]]];
            break;
        case 3:
            [valueLabel setString:[NSString stringWithFormat:@"%d",[[GameLayer sharedGameLayer] getCoinSpawnRate]]];
            break;
        case 4:
            [valueLabel setString:[NSString stringWithFormat:@"%d",[[GameLayer sharedGameLayer] getShieldSpawnRate]]];
            break;
            
        default:
            NSLog(@"[ERROR] invalid optionToTweakIdx[%d]",optionToTweakIdx);
            break;
    }
}

// -----------------------------------------------------------------------------------
- (void) pressedUp:(id) sender
{
    
    float angularVelocity = 0.0f;
    int bombSpawnRate = 0;
    int coinSpawnRate = 0;
    int shieldSpawnRate = 0;
    switch (optionToTweakIdx) {
        case 1:
            angularVelocity = [[GameLayer sharedGameLayer] changeGameAngularVelocityByDegree:0.1f];
            [valueLabel setString:[NSString stringWithFormat:@"%2.1f", angularVelocity]];
            break;
        case 2:
            bombSpawnRate = [[GameLayer sharedGameLayer] changeBombSpawnRateBy:10];
            [valueLabel setString:[NSString stringWithFormat:@"%d",bombSpawnRate]];
            break;
        case 3:
            coinSpawnRate = [[GameLayer sharedGameLayer] changeCoinSpawnRateBy:10];
            [valueLabel setString:[NSString stringWithFormat:@"%d",coinSpawnRate]];
            break;
        case 4:
            shieldSpawnRate = [[GameLayer sharedGameLayer] changeShieldSpawnRateBy:10];
            [valueLabel setString:[NSString stringWithFormat:@"%d",shieldSpawnRate]];
            break;
            
        default:
            NSLog(@"[ERROR] invalid optionToTweakIdx[%d]",optionToTweakIdx);
            break;
    }
    [[GameLayer sharedGameLayer] cleanUpPlayField];
}

// -----------------------------------------------------------------------------------
- (void) pressedDown:(id) sender
{
    float angularVelocity = 0.0f;
    int bombSpawnRate = 0;
    int coinSpawnRate = 0;
    int shieldSpawnRate = 0;
    switch (optionToTweakIdx) {
        case 1:
            angularVelocity = [[GameLayer sharedGameLayer] changeGameAngularVelocityByDegree:-0.1f];
            [valueLabel setString:[NSString stringWithFormat:@"%2.1f", angularVelocity]];

            break;
        case 2:
            bombSpawnRate = [[GameLayer sharedGameLayer] changeBombSpawnRateBy:-10];
            [valueLabel setString:[NSString stringWithFormat:@"%d",bombSpawnRate]];
            break;
        case 3:
            coinSpawnRate = [[GameLayer sharedGameLayer] changeCoinSpawnRateBy:-10];
            [valueLabel setString:[NSString stringWithFormat:@"%d",coinSpawnRate]];
            break;
        case 4:
            shieldSpawnRate = [[GameLayer sharedGameLayer] changeShieldSpawnRateBy:-10];
            [valueLabel setString:[NSString stringWithFormat:@"%d",shieldSpawnRate]];
            break;
            
        default:
            NSLog(@"[ERROR] invalid optionToTweakIdx[%d]",optionToTweakIdx);
            break;
    }
    [[GameLayer sharedGameLayer] cleanUpPlayField];
}

@end
