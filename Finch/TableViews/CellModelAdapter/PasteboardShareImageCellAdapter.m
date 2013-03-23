//
//  PasteboardShareImageCellAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "PasteboardShareImageCellAdapter.h"
#import "PasteboardShare.h"

@implementation PasteboardShareImageCellAdapter
- (PasteboardShare*)share {
    return (PasteboardShare*)self.model;
}

- (UIImage*) image {
    return [self share].image;
}
@end
