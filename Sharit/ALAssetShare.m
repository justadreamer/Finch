//
//  ALAssetShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/23/12.
//
//
#import "Global.h"
#import "GlobalDefaults.h"
#import "ALAssetShare.h"
#import "MacroPreprocessor.h"
@interface ALAssetShare()
@property (nonatomic,strong) UIImage* thumbnail;
@end

@implementation ALAssetShare
@synthesize asset=_asset;
@synthesize thumbnail=_thumbnail;

- (void) setAsset:(ALAsset *)asset {
    _asset = asset;
    _thumbnail = [UIImage imageWithCGImage:[_asset thumbnail]];
}

- (UIImage*)imageForSizeType:(ImageSizeType)sizeType {
    if (ImageSize_Thumb==sizeType) {
        return _thumbnail;
    } else if (ImageSize_Small==sizeType) {
        return [UIImage imageWithCGImage:[_asset aspectRatioThumbnail]];
    }
    ALAssetRepresentation* defaultRep = [_asset defaultRepresentation];
    CGImageRef fullResImg = [defaultRep fullResolutionImage];
    CGFloat scale = [self scaleForImageSizeType:sizeType];
    UIImage* img = [UIImage imageWithCGImage:fullResImg scale:1.0 orientation:defaultRep.orientation];
    img = [img fixOrientationAndScale:scale];
    return img;
}

- (CGSize)sizeForImageSizeType:(ImageSizeType)sizeType {
    if (ImageSize_Thumb==sizeType) {
        return _thumbnail.size;
    }
    CGFloat scale = [self scaleForImageSizeType:sizeType];
    CGSize size = [self imgSize];
    size = CGSizeMake(size.width*scale, size.height*scale);
    return size;
}

- (CGSize) imgSize {
    ALAssetRepresentation* defaultRep = [_asset defaultRepresentation];
    CGSize imgSize = defaultRep.dimensions;
    return imgSize;
}

- (CGFloat) scaleForImageSizeType:(ImageSizeType)sizeType {
    CGFloat scale = scales[sizeType];
    return scale>0 ? scale : 1.0;
}

@end