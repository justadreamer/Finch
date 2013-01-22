//
//  ShareCell.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@class Share;
@interface ShareCell : BaseCell
@property (nonatomic,strong) IBOutlet UIImageView* check;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* detailLabel;

@end
