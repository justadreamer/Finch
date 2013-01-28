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

- (void) updateWithAdapter:(BaseCellAdapter*)adapter {
    self.textLabel.text = [(BaseCellAdapter*)adapter mainText];
    self.detailTextLabel.text = [(BaseCellAdapter*)adapter detailText];
}

@end