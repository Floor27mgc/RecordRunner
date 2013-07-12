//
//  scoreMini.h
//  RecordRunnerARC
//
//  Created by Chris Z on 7/5/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "GameObjectBase.h"

@interface scoreMini : GameObjectBase <CCBAnimationManagerDelegate>
{
    
}

@property (nonatomic) CCLabelTTF * scoreLabel;
@property (nonatomic) CCBAnimationManager * animationManager;
@property (nonatomic) int scoreValue;

- (void) setScoreText: (NSString *) newScore;
- (int) getScore;

@end
