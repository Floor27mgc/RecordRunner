//
//  GameDebugMenu.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/12/13.
//
//

#import "CCNode.h"
#import "CCMenu.h"
#import "CCLabelTTF.h"

@interface GameDebugMenu : CCNode
- (void) pressedExit:(id) sender;
- (void) pressedDebugOption:(id) sender;
- (void) pressedGameMode:(id) sender;
- (void) pressedUp:(id) sender;
- (void) pressedDown:(id) sender;
- (void) resetToDefaultGameMode;
@property (nonatomic, strong) CCMenu *debugOptionMenu;
@property (nonatomic, strong) CCMenu *gameModeOptionMenu;
@property (nonatomic, assign) int optionToTweakIdx;
@property (nonatomic, strong) CCLabelTTF *valueLabel;
@end
