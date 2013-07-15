//
//  MenuBox.h
//  RecordRunnerARC
//
//  Created by Chris Zukowski on 4/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "SoundController.h"

@interface MenuBox : CCNode <CCBAnimationManagerDelegate>
{
    
}


- (void) toggleTab: (id) sender;
- (void) openTab:(id) sender;
- (void) closeTab:(id) sender;
- (BOOL) isOpen:(id) sender;
- (void) bounceTab: (id) sender;
@property (nonatomic, assign) BOOL * isOpen;
@property (nonatomic, assign) BOOL * beenAdded;
@property (nonatomic, strong) CCLabelTTF * finalScore;

@end