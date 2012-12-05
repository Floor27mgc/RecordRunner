//
//  GameObjectBase.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "GameLayer.h"
@class GameLayer;

@interface GameObjectBase : NSObject

@property (nonatomic, assign) CCSprite *gameObjectSprite;
@property (nonatomic, assign) GameLayer *parentGameLayer;
@property (nonatomic) int gameObjectSpeed;

// Class method.  Autorelease
+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName
             objectSpeed:(int) speed;

// Methods
- (CGRect) getObjectBound;  // Return bounds of current game object sprite

// Determines if the current game object has
// collided with the player
- (BOOL) encounter:(int) y
        withHeight:(int) height;

- (BOOL) encounter:(CGRect) box;

- (void) moveTo:(CGPoint) targetPoint;      // Move to absolute position within layer
- (void) moveBy:(CGPoint) relativePoint;    // Move by relative position compared to its
                                            // current position
- (CGPoint) getGameObjectSpritePosition;
// "Virtual methods" that the derived class should implement.
// If not implemented, this method will be called and Assert game
- (void) update: (ccTime) dt;
- (void) showNextFrame;
- (void) handleCollision;

@end
