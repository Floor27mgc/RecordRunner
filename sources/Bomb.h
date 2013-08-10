//
//  Bomb.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "GameObjectBase.h"
#import "CCBAnimationManager.h"


#define BOMB_START_POSITION ccp(100,0)
#define BOMB_NUM_ROUNDS_BEFORE_RECYCLE 10
@interface Bomb : GameObjectBase <CCBAnimationManagerDelegate>
{
    
}

- (void) makeInvincible;
- (void) makeVincible;

// gameObjectUpdateTick will keep track of how many time
// this gameObject update() in gamelayer has called this
// gameObject's showNextFrame();
@property (nonatomic, assign) int gameObjectUpdateTick;
@property (nonatomic, assign) int bombTimeLeft;
@property (nonatomic) BOOL closeCallAbove;
@property (nonatomic) BOOL closeCallBelow;
@property (nonatomic) BOOL exploded;

@end
