//
//  AlbumShare.h
//  Finch
//
//  Created by Eugene Dorfman on 3/16/13.
//
//

#import "Share.h"

@class ALAssetShare;
@interface AlbumShare : Share
@property (nonatomic,strong) ALAssetsGroup* assetsGroup;
@property (nonatomic,strong) NSMutableArray* assetShares;
@property (nonatomic,strong,readonly) UIImage* posterImage;

- (id) initWithAssetsGroup:(ALAssetsGroup*)assetsGroup;
- (void) addAssetShare:(ALAssetShare*)assetShare;
- (void) sortAssets;
- (NSInteger) numberOfPrivatePictures;
- (NSInteger) numberOfPictures;
@end