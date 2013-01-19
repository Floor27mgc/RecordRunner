//
//  GameObjectPlayer.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import "GameObjectPlayer.h"
#import "GameObjectBase.h"
#import "GameLayer.h"

@implementation GameObjectPlayer
@synthesize direction;
@synthesize playerStreak;
- (void) showNextFrame
{
    self.angleRotated = self.angleRotated + 1;
    self.gameObjectSprite.rotation = self.angleRotated;
/*    [self moveBy:ccp(direction * self.gameObjectSpeed, 0)];
    self.parentGameLayer.playerOnFireEmitter.anchorPoint = ccp(0.5,0.5);
    self.parentGameLayer.playerOnFireEmitter.sourcePosition = self.gameObjectSprite.position;
    if (self.gameObjectSprite.position.x <= PLAYER_LEFT_BOUND)
    {
        self.gameObjectSpeed = 0;
    } 
    
    if (self.gameObjectSprite.position.x >= PLAYER_RIGHT_BOUND)
    {
         self.gameObjectSpeed = 0;
    }*/
}

- (void) handleCollision
{
    
}

- (id) init
{
    if( (self=[super init]) )
    {
/*        playerStreak = [CCMotionStreak streakWithFade:0.8f
                                               minSeg:1.0f
                                                width:20
                                                color:ccc3(0, 255, 0)
                                      textureFilename:@"player.png"]; */

        direction = kMoveLeft;
    }
    return (self);
    
}

- (void) changeDirection
{
    direction = (direction == kMoveRight) ? kMoveLeft : kMoveRight;
//    self.gameObjectAngularVelocity = kPlayerSpeed;
}
@end
