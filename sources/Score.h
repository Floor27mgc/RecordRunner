//
//  Score.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/8/12.
//
//

#import <Foundation/Foundation.h>
#import "GameObjectBase.h"

@interface Score : GameObjectBase

@property (nonatomic) CCLabelBMFont * score;
@property (nonatomic) int scoreValue;

- (void) increment:(int) amount;
- (void) decrement:(int) amount;

@end
