//
//  GameOverLayer.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 12/17/12.
//
//

#import "GameLayer.h"
#import "GameOverLayer.h"

@implementation GameOverLayer

+ (id)initWithScoreString:(NSString *)score
                  winSize:(CGSize)winSize
{
    GameOverLayer * objCreated;
    objCreated = [[self alloc] init];
 
    // set GameOverLayer's size
    CGSize gameOverLayerSize;
    gameOverLayerSize.height = winSize.height - (winSize.height * .25);
    gameOverLayerSize.width  = winSize.width - (winSize.width * .25);
    [objCreated setContentSize:gameOverLayerSize];
    
    // set GameOverLayer position
    CGPoint gameOverLayerPosition;
    gameOverLayerPosition.x = winSize.width * .125;
    gameOverLayerPosition.y = winSize.height * .125;
    [objCreated setPosition:gameOverLayerPosition];
    
    // add score label to the gameOverLayer
    CCLabelBMFont * label = [CCLabelBMFont labelWithString:score fntFile:@"bitmapFontTest.fnt"
            width:(gameOverLayerSize.width * .75)
                    alignment:kCCTextAlignmentCenter];
    CGPoint scorePosition;
    scorePosition.x = gameOverLayerPosition.x + (gameOverLayerSize.width * .25);
    scorePosition.y = gameOverLayerSize.height / 2;
    [label setPosition:scorePosition];
    [objCreated addChild:label];
        
    return objCreated;
}

- (id) init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        // Add init stuff here for the base class
    }
    return (self);
}

@end
