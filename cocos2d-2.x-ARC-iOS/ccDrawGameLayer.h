//
//  ccDrawGameLayer.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
@interface ccDrawGameLayer : CCLayer {
    
}
- (id) initWithGameLayer:(GameLayer *) gamelayer;

@property (nonatomic,strong) GameLayer *parentGameLayer;
@end
