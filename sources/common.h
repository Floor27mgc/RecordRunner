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
#define COMMON_RECORD_CENTER_X 160
#define COMMON_RECORD_CENTER_Y 280  
#define COMMON_RECORD_CENTER ccp(COMMON_RECORD_CENTER_X, COMMON_RECORD_CENTER_Y)

#define COMMON_SCREEN_MARGIN_LEFT COMMON_GRID_WIDTH
#define COMMON_SCREEN_MARGIN_RIGHT (([[CCDirector sharedDirector] winSize]).width - COMMON_GRID_WIDTH)
#define PLAYER_RADIUS_OUTER_MOST (COMMON_GRID_WIDTH * (MAX_NUM_TRACK+1)-(COMMON_GRID_WIDTH/2))
#define PLAYER_RADIUS_INNER_MOST (COMMON_GRID_WIDTH/2 + COMMON_GRID_WIDTH)
#define RADIUS_FROM_TRACKNUM(_TRACKNUM) (((_TRACKNUM+1)*COMMON_GRID_WIDTH)+(COMMON_GRID_WIDTH/2))
#define TRACKNUM_FROM_RADIUS (((self.radius - (COMMON_GRID_WIDTH/2))/COMMON_GRID_WIDTH)-1)

#define COIN_POWER_FREQUENCY 11
#define CLOSE_HIT_THRESHOLD_PIXEL 20

#define COMMON_GET_NEW_RADIAL_POINT(_originPoint,_radius,_angle) \
    CGPointMake(floor(_radius * cos((double) CC_DEGREES_TO_RADIANS(-_angle)) + _originPoint.x), \
                floor(_radius * sin((double) CC_DEGREES_TO_RADIANS(-_angle)) + _originPoint.y))
#endif

#define LAUNCH_TIME_THRESHOLD_FOR_SUBSCRIPTION 2