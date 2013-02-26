//
//  PowerFireMissle.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 1/15/13.
//
//

#import "PowerFireMissle.h"

@implementation PowerFireMissle
/*
@synthesize missle = _missle;

// -----------------------------------------------------------------------------------
- (void) addPower
{
    _missle = [Missile initWithGameLayer:[GameLayer sharedGameLayer]
                        imageFileName:@"missile.gif"
                          objectSpeed:4];
    
    _missle.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
    _missle.angleRotated = 0;
    CGPoint preferredLocation = [[GameLayer sharedGameLayer] generateRandomTrackCoords];
    
    _missle.radius = preferredLocation.x - COMMON_SCREEN_CENTER.x;
    [_missle moveTo:preferredLocation];

    //add missle to parent game layer
    [[GameLayer sharedGameLayer] addChild:_missle.gameObjectSprite];
    
    [super addPower];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    [_missle showNextFrame];
    
    // if the missle has been hit, remove this power from the PowerPool
    if (_missle.isHit) {
        NSLog(@"PowerFireMissle removing self from track");
        [self resetPower];
    }
}

// -----------------------------------------------------------------------------------
- (void) resetPower
{
    [_missle resetObject];
    [super resetPower];
}
*/
@end
