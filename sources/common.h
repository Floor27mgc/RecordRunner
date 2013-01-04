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

#define COMMON_SCREEN_MARGIN_LEFT COMMON_GRID_WIDTH
#define COMMON_SCREEN_MARGIN_RIGHT (([[CCDirector sharedDirector] winSize]).width - COMMON_GRID_WIDTH)
#endif
