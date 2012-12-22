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
@synthesize noButton = _noButton;
@synthesize yesButton = _yesButton;

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
    scorePosition.y = (gameOverLayerSize.height / 2);// + (label.texture.contentSize.height);
    [label setPosition:scorePosition];
    [objCreated addChild:label];
    
    // continue label
    CCLabelBMFont * continueLabel = [CCLabelBMFont labelWithString:@"Continue?"
                                                           fntFile:@"bitmapFontTest.fnt"
                                                             width:(gameOverLayerSize.width * .75) alignment:kCCTextAlignmentCenter];
    CGPoint continueLabelPosition;
    continueLabelPosition.x = gameOverLayerPosition.x + (gameOverLayerSize.width * .06125);
    continueLabelPosition.y = gameOverLayerSize.height / 2 - 50;
    [continueLabel setPosition:continueLabelPosition];
    [objCreated addChild:continueLabel];
    
    // add buttons to gameOverLayer
    CCMenuItem * yesButton = [CCMenuItemImage itemWithNormalImage:@"yes.jpg"
                                                   selectedImage:@"yes.jpg"
                                                    target:objCreated
                                                        selector:@selector(yesTapped:)];

    [yesButton setIsEnabled:YES];
    
    CCMenuItem * noButton = [CCMenuItemImage itemWithNormalImage:@"no.png"
                                                   selectedImage:@"no.png"
                                                    target:objCreated
                                                        selector:@selector(noTapped:)];
    [noButton setIsEnabled:YES];
    
    CCMenu * menu = [CCMenu menuWithItems:yesButton, noButton, nil];
    [menu alignItemsHorizontally];
    CGPoint menuPosition;
    menuPosition.x = scorePosition.x;
    menuPosition.y = yesButton.rect.size.height;
    [menu setPosition:menuPosition];
    [objCreated addChild:menu];
    
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
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	// prevent touches from going to parent layers
    NSLog(@"i'm hereeeee!");
}

// -----------------------------------------------------------------------------------
- (void) yesTapped:(id)sender
{
    NSLog(@"Yes clicked");
    [self.parentGameLayer startOver];
    self.visible = NO;
}

// -----------------------------------------------------------------------------------
- (void) noTapped:(id)sender
{
    NSLog(@"No clicked");
    exit(0);
}

@end
