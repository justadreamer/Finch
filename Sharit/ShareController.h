//
//  ShareController.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Share;
@interface ShareController : UIViewController
@property (nonatomic,strong) Share* share;
@property (nonatomic,strong) IBOutlet UISwitch* isSharedSwitch;

+ (ShareController*) controllerWithShare:(Share*)share;
- (void) sharesRefreshed;
- (IBAction)switchValueChanged:(id)sender;
@end
