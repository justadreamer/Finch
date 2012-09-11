//
//  ShareCell.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareCell.h"
#import "Share.h"

@implementation ShareCell
@synthesize share;
@synthesize check;
@synthesize titleLabel;
@synthesize detailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) refresh {
    self.check.hidden = !self.share.isShared;
    self.titleLabel.text = self.share.name;
    self.detailLabel.text = [self.share detailsDescription];
    if (0==[self.detailLabel.text length]) {
        CGSize size = self.titleLabel.superview.bounds.size;
        CGPoint center = CGPointMake(size.width/2, size.height/2);
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, center.y);
    } else {
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.detailLabel.center.y-self.titleLabel.frame.size.height);
    }
    self.detailLabel.textColor = [self.share isDetailsDescriptionAWarning] ? [UIColor redColor] : [UIColor blueColor];
}

@end