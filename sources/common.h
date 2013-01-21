//
//  common.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 1/2/13.
//
//

#ifndef RecordRunnerARC_common_h
#define RecordRunnerARC_common_h


#define COMMON_GRID_WIDTH   32
#define COMMON_GRID_HEIGHT  32
#define COMMON_SCREEN_WIDTH (([[CCDirector sharedDirector] winSize]).width)
#define COMMON_SCREEN_HEIGHT (([[CCDirector sharedDirector] winSize]).height)
#define COMMON_SCREEN_CENTER ccp(COMMON_SCREEN_WIDTH/2, COMMON_SCREEN_HEIGHT/2)
#define COMMON_SCREEN_CENTER_X (COMMON_SCREEN_WIDTH/2)
#define COMMON_SCREEN_CENTER_Y (COMMON_SCREEN_HEIGHT/2)

#define COMMON_SCREEN_MARGIN_LEFT COMMON_GRID_WIDTH
#define COMMON_SCREEN_MARGIN_RIGHT (([[CCDirector sharedDirector] winSize]).width - COMMON_GRID_WIDTH)

#define COIN_POWER_FREQUENCY 11

#define COMMON_GET_NEW_RADIAL_POINT(_originPoint) \
    CGPointMake(floor(self.radius * cos((double) CC_DEGREES_TO_RADIANS(self.angleRotated)) + _originPoint.x), \
                floor(self.radius * sin((double) CC_DEGREES_TO_RADIANS(self.angleRotated)) + _originPoint.y))

#endif
