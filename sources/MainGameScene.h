//
//  MainGameScene.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/9/13.
//
//
#import "cocos2d.h"
#import "CCLayer.h"

@interface MainGameScene : CCLayer

+ (MainGameScene *) sharedGameLayer;
- (void) setScore:(int) score;
- (void) openDebugMenu:(id) sender;
@property (nonatomic,strong) CCLabelTTF *gameScoreLabel;
@property (nonatomic,assign) int score;


@end
