//
//  Queue.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/15/12.
//
//

#import "Queue.h"

@implementation Queue

@synthesize objectsOnTrack0;
@synthesize objectsOnTrack1;
@synthesize objectsOnTrack2;
@synthesize objectsOnTrack3;

// -----------------------------------------------------------------------------------
+ (id)initWithMinSize:(NSUInteger) size
{
    Queue * objCreated;
    objCreated = [[self alloc] init];
    objCreated.objectsOnTrack0 = [[NSMutableArray alloc] initWithCapacity:(size)];
    objCreated.objectsOnTrack1 = [[NSMutableArray alloc] initWithCapacity:(size * 2)];
    objCreated.objectsOnTrack2 = [[NSMutableArray alloc] initWithCapacity:(size * 3)];
    objCreated.objectsOnTrack3 = [[NSMutableArray alloc] initWithCapacity:(size * 4)];
    return objCreated;
}

// -----------------------------------------------------------------------------------
- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

// -----------------------------------------------------------------------------------
- (void)dealloc
{

}

// -----------------------------------------------------------------------------------
- (void)addObject:(id)object toTrack:(int)trackNum
{
    id objectArray = [self getObjectArray:trackNum];    
    if (objectArray != nil) {
        [objectArray addObject:object];
    }
}

// -----------------------------------------------------------------------------------
- (id)takeObjectFromIndex:(int) index fromTrack:(int) trackNum
{
    id objectArray = [self getObjectArray:trackNum];

    if (objectArray != nil) {
        if (index > [objectArray count] || index < 0) {
            return nil;
        }
        
        id object = [objectArray objectAtIndex:(index)];
        [objectArray removeObjectAtIndex:(index)];
        return object;
    }
    return nil;
}

// -----------------------------------------------------------------------------------
- (id)takeObjectFromTrack:(int) trackNum
{
    
    id objectArray = [self getObjectArray:trackNum];

    
    if (objectArray != nil) {
        id object = nil;
        
        if ([objectArray count] > 0) {
            //object = [[objects objectAtIndex:0] autorelease];
            object = [objectArray objectAtIndex:0];
            [objectArray removeObjectAtIndex:0];
        }
        return object;
    }
    return nil;
}

// -----------------------------------------------------------------------------------
- (id)getObjectArray:(int) trackNum
{
    id objectArray = nil;
    
    switch (trackNum) {
        case 0:
            objectArray = objectsOnTrack0;
            break;
        case 1:
            objectArray = objectsOnTrack1;
            break;
        case 2:
            objectArray = objectsOnTrack2;
            break;
        case 3:
            objectArray = objectsOnTrack3;
            break;
        default:
            NSLog(@"Invalid trackNum to add to object %@", [self description]);
            break;
    }
    return objectArray;
}

// -----------------------------------------------------------------------------------
- (BOOL) contains:(id)object
{
    return ([objectsOnTrack0 containsObject:object] ||
            [objectsOnTrack1 containsObject:object] ||
            [objectsOnTrack2 containsObject:object] ||
            [objectsOnTrack3 containsObject:object]);
}

// -----------------------------------------------------------------------------------
- (void)addObject:(id)object
{
    [_objects addObject:object];
}

// -----------------------------------------------------------------------------------
- (int) getObjectCount
{
    return ([objectsOnTrack0 count] + [objectsOnTrack1 count] +
            [objectsOnTrack2 count] + [objectsOnTrack3 count]);
}

@end
