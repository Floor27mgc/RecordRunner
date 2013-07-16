//
//  StatisticsTracker.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 3/19/13.
//
//

#import "StatisticsTracker.h"

@implementation StatisticsTracker

@synthesize average;
@synthesize total;
@synthesize count;
@synthesize min;
@synthesize max;
@synthesize typeLabel;

// -----------------------------------------------------------------------------------
- (void) reset
{
    average = 0;
    total   = 0;
    count   = 0;
    min     = 0;
    max     = 0;
}

// -----------------------------------------------------------------------------------
- (void) tick
{
    ++total;
}

// -----------------------------------------------------------------------------------
- (void) recalculateAverage
{
    ++count;
    
    average = (average + total) / count;
}

// -----------------------------------------------------------------------------------
- (void) updateMinAndMax
{
    min = total < min || min == 0 ? total : min;
    max = total > max ? total : max;
}

// -----------------------------------------------------------------------------------
- (void) refresh
{
    [self recalculateAverage];
    [self updateMinAndMax];
}

// -----------------------------------------------------------------------------------
- (NSDictionary *) getFlurryDictionary
{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:                                  [[NSNumber numberWithInt:min] stringValue],
        [typeLabel stringByAppendingString:@".min"],
                             
        [[NSNumber numberWithInt:max] stringValue],
        [typeLabel stringByAppendingString:@".max"],
                             
        [[NSNumber numberWithInt:total] stringValue],
        [typeLabel stringByAppendingString:@".total"],
                             
        [[NSNumber numberWithInt:average] stringValue],
        [typeLabel stringByAppendingString:@".average"],
                             
        [[NSNumber numberWithInt:count] stringValue],
        [typeLabel stringByAppendingString:@".count"],
                             nil];

    return params;
}

// -----------------------------------------------------------------------------------
- (NSString *) getLabelString
{
    return typeLabel;
}

@end
