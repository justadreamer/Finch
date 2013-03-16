//
//  AlbumShareCell.m
//  Finch
//
//  Created by Eugene Dorfman on 3/16/13.
//
//

#import "AlbumShareCell.h"
#import "AlbumShare.h"

@implementation AlbumShareCell

- (void) updateWithModel:(id)model {
    AlbumShare* albumShare = (AlbumShare*)model;
    self.thumbnail.image = [albumShare posterImage];
    self.titleLabel.text = albumShare.name;
    self.detailLabel.text = [NSString stringWithFormat:@"Pics: %d Private pics: %d",[albumShare numberOfPictures],[albumShare numberOfPrivatePictures]];

    CGFloat alpha = albumShare.isShared ? 1.0 : 0.2;
    self.thumbnail.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.detailLabel.alpha = alpha;
}

@end