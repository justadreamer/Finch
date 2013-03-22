//
//  ShareCell.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareCell.h"
#import "Share.h"

@interface ShareCell()
@property (nonatomic,strong) IBOutlet UIImageView* thumbnail;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* detailLabel;

@end

@implementation ShareCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateWithModel:(id)model {
    Share* share = (Share*) model;
    self.thumbnail.image = [share thumbnail];
    self.titleLabel.text = [share name];
    self.detailLabel.text = [share detailsDescription];
    self.detailLabel.textColor = [share isDetailsDescriptionAWarning] ? [UIColor redColor] : self.detailTextColor;
    CGFloat alpha = [share isShared] ? 1.0 : 0.3;
    self.titleLabel.alpha = alpha;
    self.detailLabel.alpha = alpha;
}

- (CGFloat) cellHeight {
    return 0;
}
@end