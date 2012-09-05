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
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    for (NSString* k in [sizeTypeDict allKeys]) {
        [params setObject:[self.path stringByAppendingFormat:@"?size=%@",k] forKey:[@"img_src_" stringByAppendingString:k]];
    }

    CGSize size = [self sizeForImageSizeType:ImageSize_Small];
    [params setObject:fs(size.width) forKey:@"img_width_s"];
    [params setObject:fs(size.height) forKey:@"img_height_s"];

    [self.macroPreprocessor setMacroDict:params];

    NSString* html = [self.macroPreprocessor process];

    return SAFE_STRING(html);
}

- (CGSize)sizeForImageSizeType:(ImageSizeType)sizeType {
    CGFloat w = constraints[ImageSize_Small];
    CGSize size = [self.image sizeProportionallyScaledToSize:CGSizeMake(w, w)];
    return size;
}

- (NSData*) dataForSizeType:(ImageSizeType)sizeType {
    UIImage* img = [self imageForSizeType:sizeType];
    return UIImageJPEGRepresentation(img,0.5);
}

- (ImageSizeType) imageSizeTypeFromParam:(NSString*)param {
    return [[sizeTypeDict objectForKey:param] intValue];
}

- (NSData*)dataForSizeParam:(NSString*)param {
    ImageSizeType sizeType = [self imageSizeTypeFromParam:param];
    return [self dataForSizeType:sizeType];
}

- (UIImage*)imageForSizeType:(ImageSizeType)sizeType {
    CGFloat constraint = constraints[sizeType];
    UIImage* img = nil;
    if (constraint>0 && (constraint < image.size.width || constraint < image.size.height)) {
        CGSize constraintSize = CGSizeMake(constraint, constraint);
        img = [[image proportionalScaleToSize:constraintSize] fixOrientation];
    } else {
        img = [image fixOrientation];
    }
    return img;
}
@end