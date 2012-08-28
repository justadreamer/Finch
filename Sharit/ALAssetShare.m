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

@implementation ALAssetShare
@synthesize asset;
@synthesize thumbPath;

- (NSString*) htmlBlock {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.path forKey:@"path"];
    [params setObject:self.thumbPath forKey:@"img_src"];
    CGImageRef thumb = [self.asset thumbnail];
    UIImage* thumbImg = [UIImage imageWithCGImage:thumb];
    CGSize size = thumbImg.size;
    [params setObject:@(size.width) forKey:@"img_width"];
    [params setObject:@(size.height) forKey:@"img_height"];
    [self.macroPreprocessor setMacroDict:params];
    NSString* html = [self.macroPreprocessor process];
    return SAFE_STRING(html);
}

- (NSData*) dataForPath:(NSString *)path {
    NSData* data = nil;
    if ([path contains:PATH_PREFIX_ASSET_THUMB]) {
        data = UIImageJPEGRepresentation([UIImage imageWithCGImage:asset.thumbnail],0.5);
    } else if ([path contains:PATH_PREFIX_ASSET]) {
        data = UIImageJPEGRepresentation([UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage]], 0.5);
    }
    return data;
}
@end
