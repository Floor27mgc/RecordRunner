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
/*
@synthesize parentGameLayer;
@synthesize noButton = _noButton;
@synthesize yesButton = _yesButton;

// -----------------------------------------------------------------------------------
+ (id)initWithScoreString:(NSString *)score
                    winSize:(CGSize)winSize
                    gameLayer:(GameLayer *) gamelayer
                    highScore:(bool)won
                    bankSize:(int) coinsInBank
{
    GameOverLayer * objCreated;
    objCreated = [[self alloc] init];
 
    objCreated.parentGameLayer = gamelayer;
    objCreated.isTouchEnabled = YES;
    objCreated.opacity = 125;
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
    
    // congratulations label
    NSString * congrats = nil;
    if (won) {
        congrats = @"High score!";
    } else {
        congrats = @"Failure.";
    }
    
    CCLabelBMFont * congratsLabel = [CCLabelBMFont labelWithString:congrats
                                                           fntFile:@"bitmapFontTest.fnt"
                                                             width:(gameOverLayerSize.width * .75) alignment:kCCTextAlignmentCenter];
    CGPoint congratPosition;
    congratPosition.x = gameOverLayerPosition.x + (gameOverLayerSize.width * .06125);
    congratPosition.y = (gameOverLayerSize.height / 1.25);
    [congratsLabel setPosition:congratPosition];
    [objCreated addChild:congratsLabel];
    
    // add score label to the gameOverLayer
    CCLabelBMFont * label = [CCLabelBMFont labelWithString:score fntFile:@"bitmapFontTest.fnt"
            width:(gameOverLayerSize.width * .75)
                    alignment:kCCTextAlignmentCenter];
    CGPoint scorePosition;
    scorePosition.x = gameOverLayerPosition.x + (gameOverLayerSize.width * .06125);
    scorePosition.y = (gameOverLayerSize.height / 1.5);
    [label setPosition:scorePosition];
    [objCreated addChild:label];
    
    // bank label
    NSString * bankString = [NSString  stringWithFormat:@"%@ %d", @"Bank: ", coinsInBank];
    
    CCLabelBMFont * bankLabel = [CCLabelBMFont labelWithString:bankString
                                                           fntFile:@"bitmapFontTest.fnt"
                                                             width:(gameOverLayerSize.width * .75) alignment:kCCTextAlignmentCenter];
    CGPoint bankLabelPosition;
    bankLabelPosition.x = gameOverLayerPosition.x + (gameOverLayerSize.width * .06125);
    bankLabelPosition.y = (gameOverLayerSize.height / 2);// - 25;
    [bankLabel setPosition:bankLabelPosition];
    [objCreated addChild:bankLabel];
    
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
    
    CCMenuItem * resetButton = [CCMenuItemImage itemWithNormalImage:@"reset.jpg"
                                                   selectedImage:@"reset.jpg"
                                                          target:objCreated
                                                        selector:@selector(resetTapped:)];
    [resetButton setIsEnabled:YES];

    
    CCMenu * menu = [CCMenu menuWithItems:yesButton, noButton, resetButton, nil];
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
}

// -----------------------------------------------------------------------------------
- (void) yesTapped:(id)sender
{
    [self.parentGameLayer startOver];
    self.visible = NO;
}

// -----------------------------------------------------------------------------------
- (void) noTapped:(id)sender
{
    exit(0);
}

// -----------------------------------------------------------------------------------
- (void) resetTapped:(id)sender
{
    [self.parentGameLayer resetHighScore];
}
*/
@end
