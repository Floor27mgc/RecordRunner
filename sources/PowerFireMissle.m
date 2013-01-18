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
    _missle = [Bomb initWithGameLayer:self.parentGameLayer
                        imageFileName:@"missile.gif"
                          objectSpeed:4];
    
    [_missle moveTo:BOMB_START_POSITION];
    
    [self.parentGameLayer addChild:_missle.gameObjectSprite];
    [self.parentGameLayer.powerPool.objects addObject:self];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    [_missle showNextFrame];
}

@end
