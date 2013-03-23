//
//  PasteboardShareTextCellAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "PasteboardShareTextCellAdapter.h"
#import "PasteboardShare.h"

@implementation PasteboardShareTextCellAdapter

- (PasteboardShare*) share {
    return (PasteboardShare*) self.model;
}

- (NSString*)text {
    return [self share].string;
}

@end