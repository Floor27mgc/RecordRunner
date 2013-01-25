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
#import "common.h"
@implementation GameObjectPlayer
@synthesize direction;
@synthesize playerStreak;
@synthesize playerRadialSpeed;
@synthesize radialTravelAngle;
@synthesize playerFacingAngle;
@synthesize playerBoundingPath;

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
            [self updatePlayerSpritePath];
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
            [self updatePlayerSpritePath];
/*            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextAddPath(ctx, playerBoundingPath);
            CGContextSetStrokeColorWithColor(ctx,[UIColor blackColor].CGColor);
            CGContextStrokePath(ctx); */
        }
        
    }
    
}

- (void) updatePlayerSpritePath
{
    CGPathRelease(playerBoundingPath);
    playerBoundingPath = nil;
    playerBoundingPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(playerBoundingPath,
                      NULL,
                      self.gameObjectSprite.position.x + (COMMON_GRID_WIDTH/2),
                      self.gameObjectSprite.position.y + (COMMON_GRID_HEIGHT/2));
    CGPathAddLineToPoint(playerBoundingPath,
                         NULL,
                         self.gameObjectSprite.position.x + (COMMON_GRID_WIDTH/2),
                         self.gameObjectSprite.position.y - (COMMON_GRID_HEIGHT/2));
    CGPathAddLineToPoint(playerBoundingPath,
                         NULL,
                         self.gameObjectSprite.position.x - (COMMON_GRID_WIDTH/2),
                         self.gameObjectSprite.position.y - (COMMON_GRID_HEIGHT/2));
    CGPathAddLineToPoint(playerBoundingPath,
                         NULL,
                         self.gameObjectSprite.position.x - (COMMON_GRID_WIDTH/2),
                         self.gameObjectSprite.position.y + (COMMON_GRID_HEIGHT/2));
    
    CGPathCloseSubpath(playerBoundingPath);
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

        direction = kMoveStill;
        playerBoundingPath = NULL;
    }
    return (self);
    
}

- (void) changeDirection
{
    direction = (direction == kMoveInToOut) ? kMoveOutToIn : kMoveInToOut;
    self.playerRadialSpeed = kPlayerRadialSpeed;
//    self.radialTravelAngle = self.angleRotated;
    if (self.parentGameLayer.player.direction == kMoveInToOut)
    {
        playerBoundingPath=CGPathCreateMutable();
        CGPathMoveToPoint(playerBoundingPath,
                          NULL,
                          self.gameObjectSprite.position.x + (COMMON_GRID_WIDTH/2),
                          self.gameObjectSprite.position.y + (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(playerBoundingPath,
                             NULL,
                             COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
                                                         PLAYER_RADIUS_OUTER_MOST,
                                                         self.parentGameLayer.player.angleRotated).x+(COMMON_GRID_WIDTH/2),
                             COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
                                                         PLAYER_RADIUS_OUTER_MOST,
                                                         self.parentGameLayer.player.angleRotated).y+(COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(playerBoundingPath,
                             NULL,
                             COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
                                                         PLAYER_RADIUS_OUTER_MOST,
                                                         self.parentGameLayer.player.angleRotated).x-(COMMON_GRID_WIDTH/2),
                             COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
                                                         PLAYER_RADIUS_OUTER_MOST,
                                                         self.parentGameLayer.player.angleRotated).y-(COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(playerBoundingPath,
                             NULL,
                             self.parentGameLayer.player.gameObjectSprite.position.x - (COMMON_GRID_WIDTH/2),
                             self.parentGameLayer.player.gameObjectSprite.position.x - (COMMON_GRID_HEIGHT/2));
        CGPathCloseSubpath(playerBoundingPath);
    }
    else
    {
        playerBoundingPath=CGPathCreateMutable();
        CGPathMoveToPoint(playerBoundingPath,
                          NULL,
                          self.gameObjectSprite.position.x + (COMMON_GRID_WIDTH/2),
                          self.gameObjectSprite.position.y + (COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(playerBoundingPath,
                             NULL,
                             COMMON_SCREEN_CENTER_X+(COMMON_GRID_WIDTH/2),
                             COMMON_SCREEN_CENTER_Y+(COMMON_GRID_HEIGHT/2));
        CGPathAddLineToPoint(playerBoundingPath,
                             NULL,
                             COMMON_SCREEN_CENTER_X-(COMMON_GRID_WIDTH/2),
                             COMMON_SCREEN_CENTER_Y-(COMMON_GRID_HEIGHT/2));
        CGPathMoveToPoint(playerBoundingPath,
                          NULL,
                          self.gameObjectSprite.position.x - (COMMON_GRID_WIDTH/2),
                          self.gameObjectSprite.position.y - (COMMON_GRID_HEIGHT/2));
        CGPathCloseSubpath(playerBoundingPath);
    }
}
@end
