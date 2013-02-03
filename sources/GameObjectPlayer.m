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
@synthesize dummyPlayer;
@synthesize hasShield;


// -----------------------------------------------------------------------------------
- (void) showNextFrame
{
    if (self.playerRadialSpeed == 0)
    {
        // The player is in the center
        if (CGPointEqualToPoint(self.gameObjectSprite.position, COMMON_SCREEN_CENTER))
        {
            self.angleRotated = self.angleRotated - self.gameObjectAngularVelocity;
            self.playerFacingAngle = self.angleRotated;
        }
     
        // The player is on the outer track
        if (self.radius == PLAYER_RADIUS_OUTER_MOST)
        {
            // Rotate and move the player around the outer track
            self.angleRotated = self.angleRotated - self.gameObjectAngularVelocity;
            [self moveTo:COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,self.radius,self.angleRotated)];
            
            // Update the dummy player.  This dummy player is for collision handling.
            // It is not displayed in anyway.  This will be used to perform convertToNodeSpace method
            // so that it can compare node space with cgpath bounding box.
            self.dummyPlayer.position = COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,self.radius,self.angleRotated);
            self.playerFacingAngle = self.angleRotated - 180;
            playerBoundingPath = nil;
            playerBoundingPath = PlayerBoundingPathStill;
        }
        
        self.gameObjectSprite.rotation = self.playerFacingAngle;
        self.dummyPlayer.rotation = self.gameObjectSprite.rotation;
//        NSLog(@"self.angleRotated = %d",self.angleRotated);        
    }
    else
    {
        // Move the player along the radial direction
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
        
        // The player has arrived the outer track or the center.  This
        // means the player will not need to move along radial direction anymore
        // Also, the bounding path will be reset to be around the player itself
        // only.  Dummy player will be set to be along the outer track or the
        // center.
        if ((self.radius >=PLAYER_RADIUS_OUTER_MOST) || (self.radius <=0))
        {
            self.playerRadialSpeed = 0;
            playerBoundingPath = nil;
            playerBoundingPath = PlayerBoundingPathStill;
            self.dummyPlayer.position = COMMON_GET_NEW_RADIAL_POINT(COMMON_SCREEN_CENTER,
                                                                    self.radius,
                                                                    self.angleRotated);
        }
        
    }
    
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
        
        dummyPlayer = [[CCNode alloc]init];
        dummyPlayer.position = COMMON_SCREEN_CENTER;
        
        self.hasShield = NO;
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) setSheilded:(BOOL)trigger
{
    [self.parentGameLayer removeChild:self.gameObjectSprite cleanup:YES];
    
    if (trigger) {
        hasShield = YES;
        self.gameObjectSprite = [CCSprite spriteWithFile:@"player_with_shield.jpg"];
    } else {
        hasShield = NO;
        self.gameObjectSprite = [CCSprite spriteWithFile:@"player-hd.png"];        
    }
    
    self.gameObjectSprite.anchorPoint = ccp(0.5,0.5);
    [self.parentGameLayer addChild:self.gameObjectSprite];
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
