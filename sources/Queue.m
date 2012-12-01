//
//  Queue.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 11/15/12.
//
//

#import "Queue.h"

@implementation Queue

@synthesize objects = _objects;

+ (id)initWithSize:(NSUInteger) size
{
    Queue * objCreated;
    objCreated = [[self alloc] init];
    objCreated.objects = [[NSMutableArray alloc] initWithCapacity:(size)];
        
    return objCreated;
}

- (id)init
{
    if ((self = [super init])) {
        _objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    //[objects release];
    //[super dealloc];
}

- (void)addObject:(id)object
{
    [_objects addObject:object];
}

- (id)takeObjectFromIndex:(int) index
{
    if (index > [_objects count] || index < 0) {
        return nil;
    }

    id object = [_objects objectAtIndex:(index)];
    [_objects removeObjectAtIndex:(index)];
    return object;
}

- (id)takeObject
{
    id object = nil;
    
    if ([_objects count] > 0) {
        //object = [[objects objectAtIndex:0] autorelease];
        object = [_objects objectAtIndex:0];
        [_objects removeObjectAtIndex:0];
    }
    
    return object;
}

@end
