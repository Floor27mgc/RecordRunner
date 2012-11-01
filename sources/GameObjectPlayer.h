//
//  GameObjectPlayer.h
//  recordRunnder
//
//  Created by Hin Lam on 10/27/12.
//
//

#import <Foundation/Foundation.h>
#import "GameObjectBase.h"
@interface GameObjectPlayer : GameObjectBase
{
    int direction;
}
- (void) changeDirection;

@property (nonatomic) int direction;
@end
