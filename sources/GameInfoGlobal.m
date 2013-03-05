//
//  GameInfoGlobal.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 3/3/13.
//
//

#import "GameInfoGlobal.h"

@implementation GameInfoGlobal
@synthesize gameMode;

static GameInfoGlobal *sharedGameInfoGlobal;

+ (GameInfoGlobal *) sharedGameInfoGlobal
{
    return sharedGameInfoGlobal;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        sharedGameInfoGlobal = self;
        gameMode = kGameModeNormal;
    }
    return self;
}

@end
