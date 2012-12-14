//
//  pattern.c
//  RecordRunnerARC
//
//  Created by Hin Lam on 12/12/12.
//
//
#include "pattern.h"

char injectorPatternArray[][7][7] =
{
    // kPatternTriangle
    {
        { 0, 0, 0, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 0, 0 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 1, 1, 1, 1, 1, 1, 1 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 0, 0, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 0, 0, 0 }
    },
    
    // kPatternRectangle
    {
        { 0, 0, 0, 0, 0, 0, 0 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 0, 1, 1, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0, 0, 0 }
    }
    
};

int patternNumPattern(void)
{
    return (sizeof(injectorPatternArray)/(PATTERN_NUM_ROWS * PATTERN_NUM_COLS));
}