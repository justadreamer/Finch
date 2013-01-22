//
//  ShareCell.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareCell.h"
#import "BaseCellModelAdapter.h"

@implementation ShareCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateWithAdapter:(BaseCellModelAdapter *)adapter {
    self.check.hidden = ![adapter showCheckMark];
    self.titleLabel.text = [adapter mainText];
    self.detailLabel.text = [adapter detailText];
    if (0==[self.detailLabel.text length]) {
        CGSize size = self.titleLabel.superview.bounds.size;
        CGPoint center = CGPointMake(size.width/2, size.height/2);
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, center.y);
    } else {
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.detailLabel.center.y-self.titleLabel.frame.size.height);
    }
    self.detailLabel.textColor = [adapter detailTextColor];
}

@end