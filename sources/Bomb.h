//
//  Bomb.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "GameObjectBase.h"
#define BOMB_START_POSITION ccp(100,0)
#define BOMB_NUM_ROUNDS_BEFORE_RECYCLE 10
@interface Bomb : GameObjectBase
{
    
}

- (void) makeInvincible;
- (void) makeVincible;

// gameObjectUpdateTick will keep track of how many time
// this gameObject update() in gamelayer has called this
// gameObject's showNextFrame();
@property (nonatomic, assign) int gameObjectUpdateTick;
@property (nonatomic) BOOL closeCallAbove;
@property (nonatomic) BOOL closeCallBelow;

@end
