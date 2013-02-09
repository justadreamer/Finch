//
//  ViewController.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SharesProvider;

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (void) refresh;

@property (nonatomic,strong) IBOutlet UITableView* mainTableView;
@property (nonatomic,strong) SharesProvider* sharesProvider;

@end
