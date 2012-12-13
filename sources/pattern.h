//
//  pattern.h
//  RecordRunnerARC
//
//  Created by Hin Lam on 12/12/12.
//
//

#ifndef RecordRunnerARC_pattern_h
#define RecordRunnerARC_pattern_h

#define PATTERN_NUM_ROWS 7
#define PATTERN_NUM_COLS 7
#define PATTERN_NUM_PATTERNS sizeof(injectorPatternArray)/(PATTERN_NUM_ROWS * PATTERN_NUM_COLS)
extern char injectorPatternArray[][7][7];

#endif
