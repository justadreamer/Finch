//
//  ALAssetShare.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/23/12.
//
//

#import "ImageShare.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetShare : ImageShare
@property (nonatomic,strong) ALAsset* asset;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,readonly) ALAssetRepresentation* defaultRepresentation;

+ (BOOL)isAssetVideo:(ALAsset*)asset;
@end
