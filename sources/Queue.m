//
//  Queue.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/15/12.
//
//

#import "Queue.h"
#import "GameObjectBase.h"

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
/*    objCreated.objectsOnTrack0 = [[NSMutableArray alloc] init];
    objCreated.objectsOnTrack1 = [[NSMutableArray alloc] init];
    objCreated.objectsOnTrack2 = [[NSMutableArray alloc] init];
    objCreated.objectsOnTrack3 = [[NSMutableArray alloc] init]; */
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
            NSLog(@"Invalid trackNum %i to add to object %@", trackNum,
                  [self description]);
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
- (BOOL) contains:(id)object onTrack:(int)trackNum
{
    switch (trackNum) {
        case 0:
            return [objectsOnTrack0 containsObject:object];
            break;
        case 1:
            return [objectsOnTrack1 containsObject:object];
            break;
        case 2:
            return [objectsOnTrack2 containsObject:object];
            break;
        case 3:
            return [objectsOnTrack3 containsObject:object];
            break;
        default:
            return NO;
    }
}

// -----------------------------------------------------------------------------------
- (void) removeObjectFromTrack:(int)trackNum withObject:(id)object
{
    NSMutableArray * targetTrack = nil;
    
    switch (trackNum) {
        case 0:
            targetTrack = objectsOnTrack0;
            break;
        case 1:
            targetTrack = objectsOnTrack1;
            break;
        case 2:
            targetTrack = objectsOnTrack2;
            break;
        case 3:
            targetTrack = objectsOnTrack3;
            break;
        default:
            break;
    }

    if (targetTrack != nil) {
        NSInteger i = [targetTrack indexOfObjectIdenticalTo:object];

        // only call resetObject on those objects that support it
        if ([[targetTrack objectAtIndex:i] respondsToSelector:@selector(resetObject)]) {
            [[targetTrack objectAtIndex:i] resetObject];
        }
        
        [targetTrack removeObjectAtIndex:i];
            
    }
}

// -----------------------------------------------------------------------------------
- (void) clearTracks
{
    [objectsOnTrack0 removeAllObjects];
    [objectsOnTrack1 removeAllObjects];
    [objectsOnTrack2 removeAllObjects];
    [objectsOnTrack3 removeAllObjects];
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
