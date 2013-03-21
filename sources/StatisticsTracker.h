//
//  StatisticsTracker.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 3/19/13.
//
//

#import <Foundation/Foundation.h>

@interface StatisticsTracker : NSObject

// increment total counter
- (void) reset;

// increment total counter
- (void) tick;

// recalculate average
- (void) recalculateAverage;

// check for min or max
- (void) updateMinAndMax;

// trigger stats recalculations
- (void) refresh;

// return Flurry-formatted NSDictionary
- (NSDictionary *) getFlurryDictionary;

//
- (NSString *) getLabelString;

@property (nonatomic) double average;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger min;
@property (nonatomic) NSInteger max;

@property (nonatomic, strong) NSString * typeLabel;

@end
