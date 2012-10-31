//
//  GameObjectBase.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface GameObjectBase : NSObject
{
/*    CCSprite *gameObjectSprite;    // Sprite representing this game object
    GameLayer *parentGameLayer; */  // Reference of the game layer this object
    // belongs to
}
@property (nonatomic, assign) CCSprite *gameObjectSprite;
@property (nonatomic, assign) GameLayer *parentGameLayer; 
@property (nonatomic) int gameObjectSpeed;

// Class method.  Autorelease
+ (id) initWithGameLayer:(GameLayer *) gamelayer
           imageFileName:(NSString *) fileName;

// Methods
- (CGRect) getObjectBound;  // Return bounds of current game object sprite
- (BOOL) encounter;         // Determines if the current game object has
// collided with the player

- (void) moveTo:(CGPoint) targetPoint;      // Move to absolute position within layer
- (void) moveBy:(CGPoint) relativePoint;    // Move by relative position compared to its
// current position

// "Virtual methods" that the derived class should implement.
// If not implemented, this method will be called and Assert game
- (void) update: (ccTime) dt;
- (void) showNextFrame;
- (void) handleCollision;

@end
