//
//  RankLayerSubBox.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/25/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "GameObjectCheck.h"


@interface RankLayerSubBox : CCNode <CCBAnimationManagerDelegate>

- (void) setMenuData:(NSMutableArray *) thisRanksAchievements
whatWasAchieved: (NSMutableArray *) thisWasAchieved
         currentRank: (int) myRank;

- (void) testMethod;


@property (nonatomic) CCSprite * checkArt;

@property (nonatomic, strong) CCLabelTTF * rankLabel;
@property (nonatomic, strong) CCLabelTTF * goal1;
@property (nonatomic, strong) CCLabelTTF * goal2;
@property (nonatomic, strong) CCLabelTTF * goal3;


@property (nonatomic, strong) GameObjectCheck * goal1_check;
@property (nonatomic, strong) GameObjectCheck * goal2_check;
@property (nonatomic, strong) GameObjectCheck * goal3_check;

@end



