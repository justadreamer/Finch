//
//  ShareCell.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Share;
@interface ShareCell : UITableViewCell
@property (nonatomic,strong) Share* share;
@property (nonatomic,strong) IBOutlet UIImageView* check;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* detailLabel;

- (void) refresh;
@end
