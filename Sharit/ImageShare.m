//
//  ImageShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
#import "ImageShare.h"
#import "UIImage+Additions.h"
#import "MacroPreprocessor.h"
#import "BasicTemplateLoader.h"
#import "Helper.h"
#import "GlobalDefaults.h"

NSDictionary* sizeTypeDict;
const CGFloat scales[] = {
    0,      // actual
    0.25,   // small
    0.5,    // medium
    0.75,   // large
    0.25,   // thumbnail
};

@implementation ImageShare
@synthesize image;

- (id) init {
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizeTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                NI(ImageSize_Actual),   @"a",
                NI(ImageSize_Small),    @"s",
                NI(ImageSize_Medium),   @"m",
                NI(ImageSize_Large),    @"l",
                NI(ImageSize_Thumb),    @"t",
                nil];
    });
    return self;
}

- (NSString*) htmlBlock {
    NSMutableDictionary* params = [self macroDictParams];
    [self.macroPreprocessor setMacroDict:params];

    NSString* html = [self.macroPreprocessor process];

    return SAFE_STRING(html);
}

- (NSMutableDictionary*)macroDictParams {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    for (NSString* k in [sizeTypeDict allKeys]) {
        [params setObject:[self.path stringByAppendingFormat:@"?size=%@",k] forKey:[@"img_src_" stringByAppendingString:k]];
        CGSize size = [self sizeForImageSizeType:[[sizeTypeDict objectForKey:k] intValue]];
        NSString* s = [NSString stringWithFormat:@"%.0fx%.0f",size.width,size.height];
        [params setObject:s forKey:[NSString stringWithFormat:@"img_size_%@",k]];
    }
    
    CGSize size = [self sizeForImageSizeType:ImageSize_Thumb];
    [params setObject:fs(size.width) forKey:@"img_width_t"];
    [params setObject:fs(size.height) forKey:@"img_height_t"];
    return params;
}

- (CGSize)sizeForImageSizeType:(ImageSizeType)sizeType {
    CGSize size = self.image.size;
    CGFloat scale = scales[sizeType];
    size = CGSizeMake(size.width*scale, size.height*scale);
    return size;
}

- (NSData*) dataForSizeType:(ImageSizeType)sizeType {
    UIImage* img = [self imageForSizeType:sizeType];
    return UIImagePNGRepresentation(img);
}

- (ImageSizeType) imageSizeTypeFromParam:(NSString*)param {
    return [[sizeTypeDict objectForKey:param] intValue];
}

- (NSData*)dataForSizeParam:(NSString*)param {
    ImageSizeType sizeType = [self imageSizeTypeFromParam:param];
    return [self dataForSizeType:sizeType];
}

- (UIImage*)imageForSizeType:(ImageSizeType)sizeType {
    CGFloat scale = scales[sizeType];
    UIImage* img = nil;
    if (scale>0) {
        CGSize size = [self sizeForImageSizeType:sizeType];
        img = [[image scaleToSize:size] fixOrientation];
    } else {
        img = [image fixOrientation];
    }
    return img;
}
@end