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
#import "BasicTemplateLoader.h"
#import "GlobalDefaults.h"
#import "ImageShare.h"

#define CLIPBOARD @"clipboard"
#define CLIPBOARD_IMAGE @"clipboard_image"

@interface SharesMacroPreprocessor ()

@end

@implementation SharesMacroPreprocessor

- (id) init {
    BasicTemplateLoader* basicLoader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:templateExt];
    self = [super initWithLoader:basicLoader templateName:@"index" macroDictionary:[self clipboardMacroDict]];
    return self;
}

- (NSDictionary*)clipboardMacroDict {
    ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];
    ImageShare* imageShare = [clipboardShare imageShare];
    NSMutableDictionary* clipboardMacroDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
[NSNumber numberWithBool:[clipboardShare isShared]],@"clipboard_is_shared",
SAFE_STRING([clipboardShare string]), @"clipboard_text",
[NSNumber numberWithBool:nil!=[clipboardShare image]],@"clipboard_image",
 [imageShare htmlBlock],@"clipboard_image_share",nil];
    
    return clipboardMacroDict;
}

@end