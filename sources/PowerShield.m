//
//  PowerShield.m
//  RecordRunnerARC
//
//  Created by Matt Cleveland on 2/2/13.
//
//

#import "PowerShield.h"
#import "GameInfoGlobal.h"

@implementation PowerShield

@synthesize startTime = _startTime;
@synthesize startedBlink = _startedBlink;
@synthesize lastToggle = _lastToggle;

// -----------------------------------------------------------------------------------
//When the player collects the shield this sets everything to react
- (void) addPower
{
    _startTime = [NSDate date];
    [[GameLayer sharedGameLayer].player setSheilded:YES];
    
    [[GameLayer sharedGameLayer] activateInvincible];
    
    _startedBlink = NO;
    _lastToggle = 0;
    [GameInfoGlobal sharedGameInfoGlobal].bombsKilledThisShield = 0;
    [super addPower];
    
    [[[GameInfoGlobal sharedGameInfoGlobal].statsContainer at:SHIELD_STATS] tick];
}

// -----------------------------------------------------------------------------------
- (void) runPower
{
    NSTimeInterval elapsed = abs([_startTime timeIntervalSinceNow]);
    
    // convert time elapsed to milliseconds
    double elapsedMilliseconds = [_startTime timeIntervalSinceNow] * -1000.0;

    // toggle first invincible record
    if (!_startedBlink) {
        [GameLayer sharedGameLayer].invincibleRecord.visible = YES;
        _startedBlink = YES;
        
        // So we just got the shield, we want to make the Bomb
        // easier to collect.  We are changing the radius hit box for
        // bomb to be between coin and regular bomb hitbox size.
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
            
            NSArray *objectsUsed = POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].bombUsedPool, trackNum);
            NSArray *objectsFree = POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].bombFreePool, trackNum);
            
            for (int i=0; i<[objectsUsed count]; i++)
            {
                GameObjectBase *gameObject = [objectsUsed objectAtIndex:i];
                gameObject.radiusHitBox = COMMON_GRID_WIDTH/3;
            }
            
            for (int i=0; i<[objectsFree count]; i++)
            {
                GameObjectBase *gameObject = [objectsFree objectAtIndex:i];
                gameObject.radiusHitBox = COMMON_GRID_WIDTH/3;
            }
        }
    } else {
        [self toggleInvincibleRecord:(int)elapsedMilliseconds];
    }
    
    if (elapsed > SHIELD_LIFETIME_SEC) {
        NSLog(@"Shield has expired");
        [[GameLayer sharedGameLayer].player setSheilded:NO];
        [GameLayer sharedGameLayer].invincibleRecord.visible = NO;
        _startedBlink = NO;
        _lastToggle = 0;
        
        [[GameLayer sharedGameLayer] deactivateInvincible];
        
        // Shield is going away.  We are reset the hit box for bombs
        // back to the original size.
        for (int trackNum = 0; trackNum < MAX_NUM_TRACK; ++trackNum) {
        
            NSArray *objectsUsed = POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].bombUsedPool, trackNum);
            NSArray *objectsFree = POOL_OBJS_ON_TRACK([GameLayer sharedGameLayer].bombFreePool, trackNum);
            
            for (int i=0; i<[objectsUsed count]; i++)
            {
                GameObjectBase *gameObject = [objectsUsed objectAtIndex:i];
                gameObject.radiusHitBox = COMMON_GRID_WIDTH/4;
            }
            
            for (int i=0; i<[objectsFree count]; i++)
            {
                GameObjectBase *gameObject = [objectsFree objectAtIndex:i];
                gameObject.radiusHitBox = COMMON_GRID_WIDTH/4;
            }                
        }


        [super resetPower];
    }
}

// -----------------------------------------------------------------------------------
- (void) toggleInvincibleRecord:(int)elapsedMilliseconds
{
    bool toggle = [GameLayer sharedGameLayer].invincibleRecord.visible;
    
    if (elapsedMilliseconds > 5000 &&
        (int)_lastToggle < 5000) {
        toggle = NO;
        _lastToggle = 5000;
    } else if (elapsedMilliseconds > 4875 &&
               (int)_lastToggle < 4875) {
        toggle = YES;
        _lastToggle = 4875;
    } else if (elapsedMilliseconds > 4750 &&
               (int)_lastToggle < 4750) {
        toggle = NO;
        _lastToggle = 4750;
    } else if (elapsedMilliseconds > 4625 &&
               (int)_lastToggle < 4625) {
        toggle = YES;
                _lastToggle = 4625;
    } else if (elapsedMilliseconds > 4500 &&
               (int)_lastToggle < 4500) {
        toggle = NO;
        _lastToggle = 4500;
    } else if (elapsedMilliseconds > 4375 &&
               (int)_lastToggle < 4375) {
        toggle = YES;
        _lastToggle = 4375;
    } else if (elapsedMilliseconds > 4250 &&
               (int)_lastToggle < 4250) {
        toggle = NO;
        _lastToggle = 4250;
    } else if (elapsedMilliseconds > 4125 &&
               (int)_lastToggle < 4125) {
        toggle = YES;
        _lastToggle = 4125;
    } else if (elapsedMilliseconds > 4000 &&
               (int)_lastToggle < 4000) {
        toggle = NO;
        _lastToggle = 4000;
    } /*else if (elapsedMilliseconds > 3750 &&
               (int)_lastToggle < 3750) {
        toggle = YES;
        _lastToggle = 3750;
    } else if (elapsedMilliseconds > 3500 &&
               (int)_lastToggle < 3500) {
        toggle = NO;
        _lastToggle = 3500;
    } else if (elapsedMilliseconds > 3000 &&
               (int)_lastToggle < 3000) {
        toggle = YES;
        _lastToggle = 3000;
    } else if (elapsedMilliseconds > 2500 &&
               (int)_lastToggle < 2500) {
        toggle = NO;
        _lastToggle = 2500;
    } else if (elapsedMilliseconds > 2000 &&
               (int)_lastToggle < 2000) {
        toggle = YES;
        _lastToggle = 2000;
    } else if (elapsedMilliseconds > 1000 &&
               (int)_lastToggle < 1000) {
        toggle = NO;
        _lastToggle = 1000;
    }*/
    
    [GameLayer sharedGameLayer].invincibleRecord.visible = toggle;
}

@end
