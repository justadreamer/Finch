//
//  PictureViewCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/31/13.
//
//

#import "PictureViewCell.h"
#import "ALAssetShare.h"

@interface PictureViewCell()
@property (nonatomic,strong) IBOutlet UIImageView* imageView;
@property (nonatomic,strong) IBOutlet UIImageView* privacyImageView;
@end

@implementation PictureViewCell

- (void)setImage:(UIImage*) image {
    self.imageView.image = image;
}

- (void) setAssetShare:(ALAssetShare *)assetShare {
    _assetShare = assetShare;
    [self refresh];
}

- (void) refresh {
    [self setImage:[_assetShare imageForSizeType:ImageSize_Thumb]];
    self.imageView.alpha = _assetShare.isPrivate ? 0.4 : 1.0;
    self.privacyImageView.hidden = !_assetShare.isPrivate;
}
@end