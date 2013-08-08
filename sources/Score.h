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

#define kSpeedUpScoreInterval     50
#define kSpeedUpScoreLevelCeiling  3

@interface Score : GameObjectBase

@property (nonatomic) CCLabelBMFont * score;
@property (nonatomic) int scoreValue;
@property (nonatomic) int prevScore;
@property (nonatomic) NSString * label;
@property  (nonatomic) int multiplierValue;


- (id) init;
- (void) prepareScore:(NSString *) myLabel;
- (void) incrementScore:(int) amount;
- (void) decrementScore:(int) amount;
- (void) addToScore:(int) amount;
- (void) setScoreValue:(int) newScore;
- (int) getScore;
- (int) getMultiplier;
- (void) setHighScore;
+ (int) getHighScore;
@end
