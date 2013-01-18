//
//  Queue.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/15/12.
//
//

#import <Foundation/Foundation.h>



@interface Queue : NSObject

@property (nonatomic) NSMutableArray * objects;

+ (id)initWithSize:(NSUInteger)size;
- (void) addObject:(id)object;
- (id) takeObjectFromIndex:(int) index;
- (id) takeObject;
- (BOOL) contains:(id)object;

@end
