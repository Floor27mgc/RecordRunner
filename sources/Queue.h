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

- (void) addObject:(id)object;
- (id) takeObject;

@end
