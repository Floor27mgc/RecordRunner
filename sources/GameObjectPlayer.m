//
//  GameObjectPlayer.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import "GameObjectPlayer.h"

@implementation GameObjectPlayer
@synthesize direction;

- (void) showNextFrame
{
    if (self.gameObjectSprite.position.x == 100)
    {
        direction = 1;
    }
    
    if (self.gameObjectSprite.position.x == 700)
    {
        direction = -1;
    };
    
    [self moveBy:ccp(direction * self.gameObjectSpeed, 0)];
    
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
        direction = 1;
        self.gameObjectSpeed = 50;
    }
    return (self);
    
}

@end
