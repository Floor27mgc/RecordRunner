//
//  GameLayer.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameObjectPlayer.h"
// GameLayer
@interface GameLayer : CCLayer
{
//    GameObjectPlayer *player;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@property (nonatomic, strong) GameObjectPlayer *player;
@property (nonatomic, strong) CCSprite *background;
@end
