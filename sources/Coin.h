//
//  Coin.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "GameObjectBase.h"
#define COIN_START_POSITION ccp(200,0)

@interface Coin : GameObjectBase
{
    
}

-(void) bounce;
-(void) scaleMe:(double) factor;

@property (nonatomic, assign) CCParticleSystemQuad *emitter;
@property (nonatomic) BOOL bouncing;

@end
