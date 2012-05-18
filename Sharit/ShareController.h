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
+ (ShareController*) controllerWithShare:(Share*)share;
@end
