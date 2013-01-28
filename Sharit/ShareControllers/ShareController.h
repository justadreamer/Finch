//
//  ShareController.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"

@class Share;

@interface ShareController : UITableViewController
@property (nonatomic,strong) Share* share;
@property (nonatomic,strong) TableModel* tableModel;
+ (ShareController*) controllerWithShare:(Share*)share;
- (void) sharesRefreshed;
- (void)switchValueChanged:(id)sender;

//this method needs to be overriden in sub-classes:
//and don't forget to call super (to add a top section for switching)
- (void) initTableModel;
@end
