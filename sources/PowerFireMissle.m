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
    
    _missle.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
    _missle.angleRotated = 0;
    CGPoint preferredLocation = [self.parentGameLayer generateRandomTrackCoords];
    
    _missle.radius = preferredLocation.x - COMMON_SCREEN_CENTER.x;
    [_missle moveTo:preferredLocation];
    
    //PATTERN_ALIGN_TO_GRID(preferredLocation);
    //int trackNum = (preferredLocation.x - COMMON_SCREEN_CENTER_X) / COMMON_GRID_WIDTH;
    self.myTrackNum = arc4random() % 4;
    
    //add missle to parent game layer
    [self.parentGameLayer addChild:_missle.gameObjectSprite];
    
    // add self to parent game layer
    [self.parentGameLayer.powerPool addObject:self toTrack:self.myTrackNum];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    [_missle showNextFrame];
    
    // if the missle has been hit, remove this power from the PowerPool
    if (_missle.isHit) {
        NSLog(@"PowerFireMissle removing self from track");
        [self.parentGameLayer.powerPool removeObjectFromTrack:self.myTrackNum
                                                withObject:self];
    }
}

// -----------------------------------------------------------------------------------
- (void) resetObject
{
    [_missle resetObject];
}

@end
