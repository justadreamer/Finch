//
//  BaseCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import "BaseCell.h"
#import "BaseCellModelAdapter.h"

@implementation BaseCell

- (void) updateWithAdapter:(BaseCellModelAdapter*)adapter {
    self.textLabel.text = [adapter mainText];
    self.detailTextLabel.text = [adapter detailText];
}

@end