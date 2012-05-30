//
//  SharesResponseFormatter.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Global.h"
#import "SharesMacroPreprocessor.h"
#import "SharesProvider.h"
#import "ClipboardShare.h"
#import "Helper.h"

#define CLIPBOARD @"clipboard"
#define CLIPBOARD_IMAGE @"clipboard_image"

@interface SharesMacroPreprocessor ()

@end

@implementation SharesMacroPreprocessor

- (id) init {
    self = [super initWithTemplateName:@"index" macroDictionary:[self clipboardMacroDict]];
    return self;
}

- (NSDictionary*)clipboardMacroDict {
    ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];
    NSMutableDictionary* clipboardMacroDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithBool:[clipboardShare isShared]],@"clipboard_is_shared",
                          SAFE_STRING([clipboardShare string]), @"clipboard_text",
                          [NSNumber numberWithBool:nil!=[clipboardShare image]],@"clipboard_image",
    
                          SAFE_STRING([Helper clipboardImageSrc]),@"clipboard_image_src",
                          [self f_to_int_s:[clipboardShare imageSize].width],@"clipboard_image_width",
                          [self f_to_int_s:[clipboardShare imageSize].height],@"clipboard_image_height",
    
                          SAFE_STRING([Helper clipboardThumbImageSrc]),@"clipboard_thumb_image_src",
                          [self f_to_int_s:[clipboardShare thumbSize].width],@"clipboard_thumb_image_width",
                          [self f_to_int_s:[clipboardShare thumbSize].height],@"clipboard_thumb_image_height",
                 nil];
    return clipboardMacroDict;
}

@end