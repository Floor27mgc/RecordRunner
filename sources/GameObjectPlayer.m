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
    [self moveBy:ccp(direction * self.gameObjectSpeed, 0)];
    playerStreak.position = [self getGameObjectSpritePosition];

    if (self.gameObjectSprite.position.x <= 100)
    {
        [self moveTo:ccp(100, self.getGameObjectSpritePosition.y ) ];
        self.gameObjectSpeed = 0;
    }
    
    if (self.gameObjectSprite.position.x >= 700)
    {
        
        [self moveTo:ccp(700, self.getGameObjectSpritePosition.y ) ];
        self.gameObjectSpeed = 0;
    }
    
}

/*+ (id) initWithGameLayer:(GameLayer *) gamelayer imageFileName:(NSString *) fileName
{
    return [super initWithGameLayer:gamelayer imageFileName:fileName];
}*/

- (void) handleCollision
{
    
}

- (id) init
{
    if( (self=[super init]) )
    {
        playerStreak = [CCMotionStreak streakWithFade:0.8f
                                               minSeg:1.0f
                                                width:50
                                                color:ccc3(0, 255, 0)
                                      textureFilename:@"player.png"];

        direction = 1;

    }
    return (self);
    
}

- (void) changeDirection
{
    direction = (direction == kMoveRight) ? kMoveLeft : kMoveRight;
    self.gameObjectSpeed = kPlayerSpeed;
}
@end
