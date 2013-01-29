//
//  BaseCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import "BaseCell.h"
#import "BaseCellAdapter.h"

@implementation BaseCell
@synthesize tableView;

- (void) updateWithAdapter:(BaseCellAdapter*)adapter {
    self.textLabel.text = [(BaseCellAdapter*)adapter mainText];
    self.detailTextLabel.text = [(BaseCellAdapter*)adapter detailText];
}

- (CGFloat) cellHeight {
    return 0;
}

@end