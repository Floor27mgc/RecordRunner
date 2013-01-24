//
//  Queue.h
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/15/12.
//
//

#import <Foundation/Foundation.h>

// _TRACKNUM are 0 based
#define POOL_OBJ_COUNT_ON_TRACK(_POOL,_TRACKNUM) [POOL_OBJS_ON_TRACK(_POOL,_TRACKNUM) count]
#define POOL_OBJS_ON_TRACK(_POOL,_TRACKNUM) [_POOL getObjectArray:_TRACKNUM]
@interface Queue : NSObject

@property (nonatomic) NSMutableArray * objectsOnTrack0;
@property (nonatomic) NSMutableArray * objectsOnTrack1;
@property (nonatomic) NSMutableArray * objectsOnTrack2;
@property (nonatomic) NSMutableArray * objectsOnTrack3;
@property (nonatomic) NSMutableArray * objects;

+ (id)initWithMinSize:(NSUInteger)size;
- (void)addObject:(id)object toTrack:(int)trackNum;
- (void) addObject:(id)object;
- (id)takeObjectFromIndex:(int) index fromTrack:(int) trackNum;
- (id)takeObjectFromTrack:(int) trackNum;
- (id)getObjectArray:(int) trackNum;
- (BOOL) contains:(id)object;
- (int) getObjectCount;

@end
