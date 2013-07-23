//
//  GameObjectCheck.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 7/21/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"


@interface GameObjectCheck : CCNode <CCBAnimationManagerDelegate>

@property (nonatomic) CCSprite * checkArt;

- (void) showExistingCheck;
- (void) showNewCheck;
- (void) hideCheck;
@end



