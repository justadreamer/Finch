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

static CGFloat constraints[] = {
        0,      // actual
        200,    // small
        400,    // medium
        800     // large
};


@implementation ImageShare
@synthesize image;
@synthesize path;

static NSDictionary* sizeTypeDict;

- (id) init {
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizeTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                NI(ImageSize_Actual),   @"a",
                NI(ImageSize_Small),    @"s",
                NI(ImageSize_Medium),   @"m",
                NI(ImageSize_Large),    @"l",
                nil];
    });
    return self;
}

- (NSString*) htmlBlock {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    for (NSString* k in [sizeTypeDict allKeys]) {
        [params setObject:[path stringByAppendingFormat:@"?size=%@",k] forKey:[NSString stringWithFormat:@"img_src_size_%@",k]];
    }
    NSString* constraint_s = [NSString stringWithFormat:@"%.0f",constraints[ImageSize_Small]];
    [params setObject:constraint_s forKey:@"img_width_s"];
    [params setObject:constraint_s forKey:@"img_height_s"];
    BasicTemplateLoader* basicLoader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:[GlobalDefaults templateExt]];
    MacroPreprocessor* mp = [[MacroPreprocessor alloc] initWithLoader:basicLoader templateName:@"image" macroDictionary:params];
    NSString* html = [mp process];
    return SAFE_STRING(html);
}

- (NSData*) dataForSize:(ImageSizeType)sizeType {
    CGFloat constraint = constraints[sizeType];
    UIImage* img = nil;
    if (constraint>0) {
        CGSize constraintSize = CGSizeMake(constraint, constraint);
        img = [[image proportionalScaleToSize:constraintSize] fixOrientation];
    } else {
        img = [image fixOrientation];
    }
    return UIImagePNGRepresentation(img);
}

- (ImageSizeType) imageSizeTypeFromParam:(NSString*)param {
    return [[sizeTypeDict objectForKey:param] intValue];
}

- (NSData*)dataForSizeParam:(NSString*)param {
    return [self dataForSize:[self imageSizeTypeFromParam:param]];
}

@end