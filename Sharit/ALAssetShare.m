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

+ (BOOL)isAssetVideo:(ALAsset*)asset {
    NSString* prop = [asset valueForProperty:ALAssetPropertyType];
    return [prop isEqualToString:ALAssetTypeVideo];
}

- (NSMutableDictionary*)macroDictParams {
    NSMutableDictionary* params = [super macroDictParams];
    if (_isVideo) {
        [params setObject:[self videoDuration] forKey:@"duration"];
        [params setObject:self.path forKey:@"src_video"];
    }
    return params;
}

- (ALAssetRepresentation*)defaultRepresentation {
    return _asset.defaultRepresentation;
}

- (NSString*) videoDuration {
    NSString* result = nil;
    if (_isVideo) {
        NSNumber* duration = [_asset valueForProperty:ALAssetPropertyDuration];
        if ([duration isKindOfClass:[NSNumber class]]) {
            double d = [duration doubleValue];
            result = [ALAssetShare durationStringFromDouble:d];
        }
    }
    return SAFE_STRING(result);
}

- (NSData*) dataForSizeType:(ImageSizeType)sizeType {
    if (_isVideo && sizeType!=ImageSize_Thumb) {
        return nil;
    }
    return [super dataForSizeType:sizeType];
}

+ (NSString*) durationStringFromDouble:(double)d {
    NSString* result = @"";
    const int sH = 3600;
    const int sM = 60;
    NSString* const PADDED_FORMAT=@"%02d";
    NSString* const SIMPLE_FORMAT=@"%d";
    int seconds = (int)d;
    if (seconds>=sH) {
        result = [result stringByAppendingFormat:@"%d:",seconds/sH];
        seconds = seconds % sH;
    }

    NSString* format = [result length] || seconds<sM ? PADDED_FORMAT : SIMPLE_FORMAT;
    result = [result stringByAppendingFormat:format,seconds/sM];
    result = [result stringByAppendingString:@":"];
    seconds = seconds % sM;

    format = [result length] ? PADDED_FORMAT : SIMPLE_FORMAT;
    result = [result stringByAppendingFormat:format,seconds];
    return result;
}
@end