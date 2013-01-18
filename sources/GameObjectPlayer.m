//
//  GameObjectPlayer.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import "GameObjectPlayer.h"
#import "GameLayer.h"

@implementation GameObjectPlayer
@synthesize direction;
@synthesize playerStreak;

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    [self moveBy:ccp(direction * self.gameObjectSpeed, 0)];
    self.parentGameLayer.playerOnFireEmitter.anchorPoint = ccp(0.5,0.5);
    self.parentGameLayer.playerOnFireEmitter.sourcePosition = self.gameObjectSprite.position;
    if (self.gameObjectSprite.position.x <= PLAYER_LEFT_BOUND)
    {
        self.gameObjectSpeed = 0;
    } 
    
    if (self.gameObjectSprite.position.x >= PLAYER_RIGHT_BOUND)
    {
         self.gameObjectSpeed = 0;
    }
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    
}

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
        direction = kMoveLeft;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) changeDirection
{
    direction = (direction == kMoveRight) ? kMoveLeft : kMoveRight;
    self.gameObjectSpeed = kPlayerSpeed;
}
@end
