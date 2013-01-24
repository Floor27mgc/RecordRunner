//
//  PowerFireMissle.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import "PowerFireMissle.h"

@implementation PowerFireMissle

@synthesize missle = _missle;

// -----------------------------------------------------------------------------------
- (void) addPower
{
    _missle = [Missile initWithGameLayer:self.parentGameLayer
                        imageFileName:@"missile.gif"
                          objectSpeed:4];
    
    // missile will start pointing at the player
    CGPoint startLoc = [self.parentGameLayer generateRandomTrackCoords];
    [_missle moveTo:startLoc];
    
    [self.parentGameLayer addChild:_missle.gameObjectSprite];
    [self.parentGameLayer.powerPool.objects addObject:self];
    [self.parentGameLayer.bombUsedPool.objects addObject:_missle];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    [_missle showNextFrame];
    
    // if the missle has been hit, remove this power from the PowerPool
    if (![self.parentGameLayer.bombUsedPool contains:_missle]) {
        NSInteger i =
            [self.parentGameLayer.powerPool.objects indexOfObjectIdenticalTo:self];
        [self.parentGameLayer.powerPool.objects removeObjectAtIndex:i];
    }
}

@end
