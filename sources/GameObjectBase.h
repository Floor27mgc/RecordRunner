//
//  GameObjectBase.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Queue.h"
#import "CCBAnimationManager.h"
#define kDefaultGameObjectAngularVelocityInDegree 1
#define TRACKNUM_FROM_RADIUS (self.radius/COMMON_GRID_WIDTH - 1)
@class GameLayer;

@interface GameObjectBase : CCSprite

@property (nonatomic, assign) CCSprite *gameObjectSprite;
@property (nonatomic, assign) GameLayer *parentGameLayer;
@property (nonatomic) int gameObjectAngularVelocity;
@property (nonatomic) int radius;
@property (nonatomic) int angleRotated;
@property (nonatomic, strong) CCBAnimationManager *animationManager;

// Class method.  Autorelease
+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed;

// Methods
- (CGRect) getObjectBound;  // Return bounds of current game object sprite
- (void) resetObject;   // Reset base game object property.  Derived
                        // class could call this using [super resetObject]
                        // in their own resetObject method to make sure the
                        // all base properties are reset in one scoop
- (void) recycleOffScreenObjWithUsedPool:(Queue *)_usedObjPool
                                freePool:(Queue *)_freeObjPool;
- (void) recycleObjectWithUsedPool:(Queue *)_usedObjPool
                          freePool:(Queue *)_freeObjPool;

// reset object and remove it from "pool"
- (BOOL) removeFromGamePool:(Queue *)pool;

// Determines if the current game object has
// collided with the player
- (BOOL) encounter:(int) y
        withHeight:(int) height;
- (BOOL) encounterWithPlayer;
- (BOOL) encounter:(CGRect) box;

- (void) moveTo:(CGPoint) targetPoint;      // Move to absolute position within layer
- (void) moveBy:(CGPoint) relativePoint;    // Move by relative position compared to its
                                            // current position
- (CGPoint) getGameObjectSpritePosition;

// "Virtual methods" that the derived class should implement.
// If not implemented, this method will be called and Assert game
- (void) update: (ccTime) dt;

// "Virtual methods" that the derived class should implement.
// If not implemented, this method will be called and Assert game
- (void) showNextFrame;
- (void) handleCollision;

@end
