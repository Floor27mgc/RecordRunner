//
//  MainGameScene.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/9/13.
//
//

#import "MainGameScene.h"
#import "CCBReader.h"
#import "common.h"
#import "GameLayer.h"

@implementation MainGameScene
@synthesize score;
static MainGameScene *sharedGameScene;
+ (MainGameScene *) sharedGameLayer
{
    return sharedGameScene;
}

-(id) init
{    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        sharedGameScene = self;
    }
    return self;
}

- (void) setScore:(int) score
{
    
}


@end

