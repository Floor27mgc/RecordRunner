//
//  Bomb.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/12/12.
//
//

#import "GameLayer.h"
#import "Bomb.h"

@implementation Bomb

// -----------------------------------------------------------------------------------
- (id) init
{
    if( (self=[super init]) )
    {
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    // this is a negative movement down the Y-axis, the Bomb is rising
    // from the bottom of the screen
    [self moveBy:ccp(0, self.gameObjectSpeed)];
    
    CCSprite * pSprite = self.parentGameLayer.player.gameObjectSprite;
    pSprite.anchorPoint = ccp(0,0);
    
    if ((pSprite.position.x > PLAYER_LEFT_BOUND) &&
        (self.parentGameLayer.player.direction == kMoveRight) &&
        (self.parentGameLayer.player.gameObjectSpeed != 0))
    {
        CGRect playerHitBox = CGRectMake(pSprite.position.x,
                                         pSprite.position.y,
                                         -kPlayerHitBoxSegmentWidth,
                                         [pSprite boundingBox].size.height);
        if ([self encounter:playerHitBox])
        {
            [self handleCollision];
        }
    }
    
    if ((pSprite.position.x < PLAYER_RIGHT_BOUND) &&
        (self.parentGameLayer.player.direction == kMoveLeft) &&
        (self.parentGameLayer.player.gameObjectSpeed != 0))
    {
        CGRect playerHitBox = CGRectMake(pSprite.position.x,
                                         pSprite.position.y,
                                         kPlayerHitBoxSegmentWidth,
                                         [pSprite boundingBox].size.height);
        if ([self encounter:playerHitBox])
        {
            [self handleCollision];
        }
    }

    
}

// -----------------------------------------------------------------------------------
- (void) handleCollision
{
    NSUInteger i;
    
    i = [self.parentGameLayer.bombUsedPool.objects indexOfObjectIdenticalTo:self];
    [[self.parentGameLayer.bombUsedPool.objects objectAtIndex:i] resetObject];
    
    [self.parentGameLayer.bombFreePool addObject:[self.parentGameLayer.bombUsedPool.objects objectAtIndex:i]];
    [self.parentGameLayer.bombUsedPool.objects removeObjectAtIndex:i];
}
@end
