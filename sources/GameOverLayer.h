//
//  GameOverLayer.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/17/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor

@property (nonatomic, assign) GameLayer * parentGameLayer;
@property (nonatomic, assign) CCMenuItem * noButton;
@property (nonatomic, assign) CCMenuItem * yesButton;
@property (nonatomic, assign) CCMenuItem * resetButton;

+ (id)initWithScoreString:(NSString *) score
                  winSize:(CGSize) winSize
                gameLayer:(GameLayer *) gamelayer
                highScore:(bool) won;
- (id) init;
- (void) yesTapped:(id) sender;
- (void) noTapped:(id) sender;
- (void) resetTapped:(id) sender;

@end
