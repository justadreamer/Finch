//
//  ShareCell.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareCell.h"
#import "ShareCellAdapter.h"

@interface ShareCell()
@property (nonatomic,strong) IBOutlet UIImageView* check;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* detailLabel;

@end

@implementation ShareCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateWithAdapter:(ShareCellAdapter *)adapter {
    self.check.hidden = ![adapter showCheckMark];
    self.titleLabel.text = [adapter mainText];
    self.detailLabel.text = [adapter detailText];
    self.detailLabel.textColor = [adapter detailTextColor];
}

- (CGFloat) cellHeight {
    return 0;
}
@end