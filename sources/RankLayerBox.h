//
//  RankLayerBox.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/6/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <GameKit/GameKit.h>

@interface RankLayerBox : CCNode <CCBAnimationManagerDelegate>


- (void) setMenuData: (NSMutableArray *) rankRequirements currentRank: (int) ranklevel;


@property (nonatomic, strong) CCLabelTTF * rankLabel;
@property (nonatomic, strong) CCLabelTTF * goal1;
@property (nonatomic, strong) CCLabelTTF * goal2;
@property (nonatomic, strong) CCLabelTTF * goal3;
@property BOOL isQuitting;


@end
