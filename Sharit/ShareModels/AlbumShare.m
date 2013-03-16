//
//  AlbumShare.m
//  Finch
//
//  Created by Eugene Dorfman on 3/16/13.
//
//

#import "AlbumShare.h"
#import "ALAssetShare.h"
#import "PicturesShare.h"
@interface AlbumShare ()
@property (nonatomic,strong,readwrite) UIImage* posterImage;
@end

@implementation AlbumShare
@synthesize name = _name;
- (id) init {
    if (self = [super init]) {
        _assetShares = [NSMutableArray new];
    }
    return self;
}

- (id) initWithAssetsGroup:(ALAssetsGroup *)assetsGroup {
    if (self = [self init]) {
        _assetsGroup = assetsGroup;
        _name = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        _posterImage = [UIImage imageWithCGImage:[_assetsGroup posterImage]];
    }
    return self;
}

- (void) addAssetShare:(ALAssetShare*)assetShare {
    [_assetShares addObject:assetShare];
}

- (void) sortAssets {
    [PicturesShare sortAssetSharesArray:_assetShares];
}

- (NSInteger) numberOfPrivatePictures {
    return [PicturesShare numberOfPrivatePicturesInAssetSharesArray:_assetShares];
}

- (NSInteger) numberOfPictures {
    return [_assetShares count];
}
@end