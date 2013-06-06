//
//  Achievement.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 6/2/13.
//
//

#import "Achievement.h"
#import "GameInfoGlobal.h"

@implementation Achievement

//@synthesize achievementCondition;
@synthesize achievementDescription;
@synthesize previouslyAchieved;
@synthesize condIndex;
@synthesize alreadyLogged;

// -----------------------------------------------------------------------------------
- (id) initWithCondition:(int)index description:(NSString *)desc
{
    if (self=[super init]) {
        //achievementCondition = cond;
        condIndex = index;
        achievementDescription = desc;
        
        // this needs to be loaded from game center's achievements
        previouslyAchieved = NO;
        alreadyLogged = NO;
    }
    
    return (self);
}

// -----------------------------------------------------------------------------------
- (BOOL) Achieved
{
    if (previouslyAchieved) {
        return YES;
    }
    
    BOOL achieved = NO;
    
    switch (condIndex) {
        case 1:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotations >= 10);
            break;
        case 2:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numCoins >= 50);
            break;
        case 3:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].closeCalls >= 3);
            break;
        case 4:
            break;
        case 5:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].score >= 200);
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            break;
        case 9:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].score >= 1000);
            break;
        case 10:
            achieved = ([GameInfoGlobal sharedGameInfoGlobal].numRotations >= 30);
            break;
        case 11:
            break;
        case 12:
            break;
        case 13:
            break;
        case 14:
            break;
        default:
            return NO;
            break;
    }
    
    // once achieved, set the flag
    // ALSO need to update gamecenter, once infrastructure is ready
    if (achieved) {
        previouslyAchieved = YES;
    }
    
    return achieved;
    
    //NSLog(@"%@ - %d", achievementCondition, [achievementCondition boolValue]);
    //return (previouslyAchieved || [achievementCondition boolValue]);
  //  NSPredicate * pred = [NSPredicate predicateWithFormat:achievementCondition];
    //NSPredicate * pred = [NSPredicate predicateWithFormat:@"[GameInfoGlobal sharedGameInfoGlobal].closeCalls >= 3"];
    //return ([pred evaluateWithObject:nil]);
/*    NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"1>0"];
    NSPredicate *predicate2=[NSPredicate predicateWithFormat:@"1<0"];
    BOOL    ok1=[predicate1 evaluateWithObject:nil];
    BOOL    ok2=[predicate2 evaluateWithObject:nil];
    NSLog(@"ok1: %d  ok2: %d",ok1,ok2);*/
    //NSLog(@"%@", achievementCondition);
    
    /*NSString * obj1 = @"[GameInfoGlobal sharedGameInfoGlobal].closeCalls";
    NSString * obj2 = @"3";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"%@ >= %@",obj1,obj2];*/
    //NSExpression * expr = [NSExpression expressionWithFormat:achievementCondition];
    //id exprVal = [expr expressionValueWithObject:nil context:nil];
    //NSLog(@"exprVal %@", exprVal);
    /*BOOL bv = [pred evaluateWithObject:nil];
    NSLog(@"pred bv is %d", bv);
    return !bv;*/
    //return ([pred evaluateWithObject:nil]);
    //return ([GameInfoGlobal sharedGameInfoGlobal].closeCalls >= 3);
}

// -----------------------------------------------------------------------------------
- (void) Log
{
    if (!alreadyLogged) {
        NSLog(@"Achieved: %@!", achievementDescription);
        alreadyLogged = YES;
    }
}

@end
