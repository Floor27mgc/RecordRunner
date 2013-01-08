//
//  GameMainMenuLayer.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "GameLayer.h"
#import "GameMainMenuLayer.h"


@implementation GameMainMenuLayer
@synthesize background;

// -----------------------------------------------------------------------------------
// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameMainMenuLayer *layer = [GameMainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// -----------------------------------------------------------------------------------
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        self.isTouchEnabled = YES;
        background = [CCSprite spriteWithFile:@"MainMenu.jpg"];
        background.anchorPoint = ccp(0,0); 
        background.position = ccp(0,0);
        background.opacity = 0;
        [background runAction:[CCFadeIn actionWithDuration:2]];
        [self addChild:background];
        [self buildMenuItems];
    }
	return self;
}

-(void) buildMenuItems
{
    // Image Item
    CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"playButton.png" selectedImage:@"playButton.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]];
//        [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
    }];
    
    CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"modeButton.png" selectedImage:@"modeButton.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
    }];

    CCMenuItem *item3 = [CCMenuItemImage itemWithNormalImage:@"newsButton.png" selectedImage:@"newsButton.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
    }];

    CCMenu *menu = [CCMenu menuWithItems:item1,item2,item3, nil];
    [menu alignItemsVertically];
    
    int periodAdjustment = 0;
    for( CCNode *child in [menu children] ) {
        
        //child.position = ccp(160,child.position.y - 120);
        child.position = ccp(160,-120 -(periodAdjustment*30));
        child.scaleX = 1.4;
        child.scaleY = 1.4;
        [child runAction:[CCEaseElasticOut actionWithAction:[CCMoveBy actionWithDuration:4 position:ccp(-260,0)] period:0.35f + (periodAdjustment*0.1)]];
        [child runAction:[CCFadeIn actionWithDuration:2]];
        periodAdjustment++;
    }
    
    [self addChild:menu];
}

// -----------------------------------------------------------------------------------
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
}


// -----------------------------------------------------------------------------------
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//	[self.player changeDirection];
}

@end
