//
//  Score.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/8/12.
//
//

#import <Foundation/Foundation.h>
#import "GameObjectBase.h"

#define kScorePositionX (size.width-100)
#define kScorePositionY (size.height-30)
@interface Score : GameObjectBase

@property (nonatomic) CCLabelBMFont * score;
@property (nonatomic) int scoreValue;

- (void) incrementScore:(int) amount;
- (void) decrementScore:(int) amount;

@end
