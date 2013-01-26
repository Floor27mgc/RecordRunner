//
//  GameObjectPlayer.m
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import "GameObjectPlayer.h"
#import "GameLayer.h"
#import "common.h"
@implementation GameObjectPlayer
@synthesize direction;
@synthesize playerStreak;
@synthesize playerRadialSpeed;
@synthesize radialTravelAngle;
@synthesize playerFacingAngle;
@synthesize playerBoundingPath;
@synthesize PlayerBoundingPathCrossing;
@synthesize PlayerBoundingPathStill;

// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    if (self.playerRadialSpeed == 0)
    {
        if (CGPointEqualToPoint(self.gameObjectSprite.position, COMMON_SCREEN_CENTER))
        {
            self.angleRotated = self.angleRotated - self.gameObjectAngularVelocity;
            self.playerFacingAngle = self.angleRotated;
        }

        
        if (self.radius == PLAYER_RADIUS_OUTER_MOST)
        {
            self.angleRotated = self.angleRotated - self.gameObjectAngularVelocity;
            [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,self.radius,self.angleRotated)];
            self.playerFacingAngle = self.angleRotated - 180;
//            CGPathRelease(playerBoundingPath);
            playerBoundingPath = nil;
            playerBoundingPath = PlayerBoundingPathStill;
//            [self updatePlayerSpritePath];
        }
        
        self.gameObjectSprite.rotation = self.playerFacingAngle;
//        NSLog(@"self.angleRotated = %d",self.angleRotated);
        
    }
    else
    {
        self.radius = self.radius + (self.playerRadialSpeed * self.direction);
        
        if (self.radius > PLAYER_RADIUS_OUTER_MOST)
        {
            self.radius = PLAYER_RADIUS_OUTER_MOST;
        }
        
        if (self.radius < 0)
        {
            self.radius = 0;
        }
        
        
        [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
                                                 self.radius,
                                                 self.angleRotated)];
    
/*        NSLog(@"radius = %d outerradius=%d x=%f, y=%f angleRotated=%d",self.radius,
              PLAYER_RADIUS_OUTER_MOST,self.gameObjectSprite.position.x,
              self.gameObjectSprite.position.y,self.angleRotated);*/
        
        if ((self.radius >=PLAYER_RADIUS_OUTER_MOST) || (self.radius <=0))
        {
            self.playerRadialSpeed = 0;
            playerBoundingPath = nil;
            playerBoundingPath = PlayerBoundingPathStill;
        }
        
    }
    
}

// -----------------------------------------------------------------------------------
- (void) updatePlayerSpritePath
{
    CGPathRelease(playerBoundingPath);
    playerBoundingPath = nil;
    playerBoundingPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(playerBoundingPath,
                      NULL,
                      (COMMON_GRID_WIDTH/2),
                      (COMMON_GRID_HEIGHT/2));
    CGPathAddLineToPoint(playerBoundingPath,
                         NULL,
                         (COMMON_GRID_WIDTH/2),
                         -(COMMON_GRID_HEIGHT/2));
    CGPathAddLineToPoint(playerBoundingPath,
                         NULL,
                         -(COMMON_GRID_WIDTH/2),
                         -(COMMON_GRID_HEIGHT/2));
    CGPathAddLineToPoint(playerBoundingPath,
                         NULL,
                         -(COMMON_GRID_WIDTH/2),
                         (COMMON_GRID_HEIGHT/2));
    
    CGPathCloseSubpath(playerBoundingPath);
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
        direction = kMoveStill;

        PlayerBoundingPathCrossing = CGPathCreateMutable();
        
        CGPathMoveToPoint(PlayerBoundingPathCrossing,
                          NULL,
                          0,
                          (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(PlayerBoundingPathCrossing,
                             NULL,
                             PLAYER_RADIUS_OUTER_MOST,
                             (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(PlayerBoundingPathCrossing,
                             NULL,
                             PLAYER_RADIUS_OUTER_MOST,
                             -(COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(PlayerBoundingPathCrossing,
                             NULL,
                             0,
                             -(COMMON_GRID_HEIGHT/2));
        CGPathCloseSubpath(PlayerBoundingPathCrossing);
        
        PlayerBoundingPathStill = CGPathCreateMutable();
        
        CGPathMoveToPoint(PlayerBoundingPathStill,
                          NULL,
                          (COMMON_GRID_WIDTH/2),
                          (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(PlayerBoundingPathStill,
                             NULL,
                             (COMMON_GRID_WIDTH/2),
                             -(COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(PlayerBoundingPathStill,
                             NULL,
                             -(COMMON_GRID_WIDTH/2),
                             -(COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(PlayerBoundingPathStill,
                             NULL,
                             -(COMMON_GRID_WIDTH/2),
                             (COMMON_GRID_HEIGHT/2));
        
        CGPathCloseSubpath(PlayerBoundingPathStill);
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) changeDirection
{
    direction = (direction == kMoveInToOut) ? kMoveOutToIn : kMoveInToOut;
    self.playerRadialSpeed = kPlayerRadialSpeed;
    playerBoundingPath = nil;
    playerBoundingPath = self.PlayerBoundingPathCrossing;    
}
@end
