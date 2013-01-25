//
//  ccDrawGameLayer.m
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "common.h"
#import "GameLayer.h"
#import "ccDrawGameLayer.h"


@implementation ccDrawGameLayer

- (void) draw
{
    glLineWidth(2);
    ccDrawColor4B(255, 0, 0, 255);
    
    for (int trackNum = 0; trackNum < MAX_NUM_TRACK; trackNum++)
    {
        ccDrawCircle(COMMON_SCREEN_CENTER, (trackNum+1)*COMMON_GRID_WIDTH+(COMMON_GRID_WIDTH/2), 0, 50, NO);
    }
    UIGraphicsBeginImageContext(self.boundingBox.size);    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, self.parentGameLayer.player.playerBoundingPath);
    CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
    CGContextStrokePath(ctx);
    UIGraphicsEndImageContext();
}

//- (void)drawRect:(CGRect)rect
/*- (void) draw
{
    UIGraphicsBeginImageContext(self.boundingBox.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    
    CGContextSetLineWidth(context, 20.0);
    
    CGContextMoveToPoint(context, 160, 240);
    CGContextAddLineToPoint(context, 160, 250);
    
    CGContextStrokePath(context);
    UIGraphicsEndImageContext();
    
}*/

- (id) initWithGameLayer:(GameLayer *) gamelayer
{
    self.parentGameLayer = gamelayer;
    return self;
}
@end
