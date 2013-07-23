//
//  RankLayerBox.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/6/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObjectCheck.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <GameKit/GameKit.h>

@interface RankLayerBox : CCNode <CCBAnimationManagerDelegate>


- (void) setMenuData:(NSMutableArray *) thisRanksAchievements
nextRanksAchievements: (NSMutableArray *) nextAchievements
         currentRank: (int) myRank
         promoteRank: (BOOL) goNextRank;

- (void)finishNewThisRoundCheckMarks;
- (void)finishExistingCheckMarks;

@property (nonatomic, strong) CCLabelTTF * rankLabel;
@property (nonatomic, strong) CCLabelTTF * goal1;
@property (nonatomic, strong) CCLabelTTF * goal2;
@property (nonatomic, strong) CCLabelTTF * goal3;

//FOR THE B CARD WHEN YOU GET A RANK PROMOTION
@property (nonatomic, strong) CCLabelTTF * rankLabel_B;
@property (nonatomic, strong) CCLabelTTF * goal1_B;
@property (nonatomic, strong) CCLabelTTF * goal2_B;
@property (nonatomic, strong) CCLabelTTF * goal3_B;



@property (nonatomic, strong) GameObjectCheck * goal1_check;
@property (nonatomic, strong) GameObjectCheck * goal2_check;
@property (nonatomic, strong) GameObjectCheck * goal3_check;
@property BOOL isQuitting;

@end
