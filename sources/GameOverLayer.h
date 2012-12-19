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

+ (id)initWithScoreString:(NSString *) score
                  winSize:(CGSize) winSize;
- (id) init;

@end
