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

@synthesize parentGameLayer;


// -----------------------------------------------------------------------------------
+ (id)initWithScoreString:(NSString *)score
                    winSize:(CGSize)winSize
                    gameLayer:(GameLayer *) gamelayer
{
    GameOverLayer * objCreated;
    objCreated = [[self alloc] init];
 
    objCreated.parentGameLayer = gamelayer;
    objCreated.isTouchEnabled = YES;
    
    // set GameOverLayer's size
    CGSize gameOverLayerSize;
    gameOverLayerSize.height = winSize.height - (winSize.height * .5);
    gameOverLayerSize.width  = winSize.width - (winSize.width * .5);
    [objCreated setContentSize:gameOverLayerSize];
    
    // set GameOverLayer position
    CGPoint gameOverLayerPosition;
    gameOverLayerPosition.x = winSize.width * .25;
    gameOverLayerPosition.y = winSize.height * .25;
    [objCreated setPosition:gameOverLayerPosition];
    
    // add score label to the gameOverLayer
    CCLabelBMFont * label = [CCLabelBMFont labelWithString:score fntFile:@"bitmapFontTest.fnt"
            width:(gameOverLayerSize.width * .75)
                    alignment:kCCTextAlignmentCenter];
    CGPoint scorePosition;
    scorePosition.x = gameOverLayerPosition.x + (gameOverLayerSize.width * .06125);
    scorePosition.y = gameOverLayerSize.height / 2;
    [label setPosition:scorePosition];
    [objCreated addChild:label];
    
    // add buttons to gameOverLayer
    CCMenuItem * yesButton = [CCMenuItemImage itemWithNormalImage:@"yes.jpg"
                                                   selectedImage:@"yes.jpg"
                                                    target:self
                                                        selector:@selector(yesTapped:)];
    CGPoint yesButtonPosition;
    yesButtonPosition.x = scorePosition.x - (yesButton.rect.size.width);
    yesButtonPosition.y = gameOverLayerSize.height - (gameOverLayerSize.height *.75);
    [yesButton setPosition:yesButtonPosition];
    
    CCMenuItem * noButton = [CCMenuItemImage itemWithNormalImage:@"no.png"
                                                   selectedImage:@"no.png"
                                                    target:self
                                                        selector:@selector(noTapped:)];
    
    CGPoint noButtonPosition;
    noButtonPosition.x = yesButtonPosition.x + yesButton.rect.size.width * 2;
    noButtonPosition.y = yesButtonPosition.y;
    [noButton setPosition:noButtonPosition];
    
    [objCreated addChild:yesButton z:10];
    [objCreated addChild:noButton z:15];
    
    return objCreated;
}

// -----------------------------------------------------------------------------------
- (id) init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        // Add init stuff here for the base class
    }
    return (self);
}

// -----------------------------------------------------------------------------------
- (void) yesTapped:(id)sender
{
    NSLog(@"Yes clicked");
    [self.parentGameLayer startOver];
}

// -----------------------------------------------------------------------------------
- (void) noTapped:(id)sender
{
    NSLog(@"No clicked");
    exit(0);
}


@end
