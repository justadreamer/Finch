//
//  PicturesSharePrivateCellAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 2/9/13.
//
//

#import "PicturesSharePrivateCellAdapter.h"
#import "PicturesShare.h"

@implementation PicturesSharePrivateCellAdapter
- (PicturesShare*) share {
    return (PicturesShare*) self.model;
}

- (NSString*) detailText {
    return [NSString stringWithFormat:@"Private pics: %d",[[self share] numberOfPrivate]];
}

@end
