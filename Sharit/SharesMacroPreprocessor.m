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
#import "TextShare.h"

#define CLIPBOARD @"clipboard"
#define CLIPBOARD_IMAGE @"clipboard_image"

@interface SharesMacroPreprocessor ()
@end

@implementation SharesMacroPreprocessor

- (id) initWithPath:(NSString*)path {
    BasicTemplateLoader* basicLoader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:templateExt];
    NSMutableDictionary* macroDict = nil;
    if ([path contains:@"text"]) {
        macroDict = [self textMacroDict];
    } else if ([path contains:@"pictures"]) {
        macroDict = [self picturesMacroDict];
    } else {
        macroDict = [self clipboardMacroDict];
    }
    [macroDict setObject:path forKey:kRedirectPath];
    self = [super initWithLoader:basicLoader templateName:@"index" macroDictionary:macroDict];

    return self;
}

- (NSMutableDictionary*)clipboardMacroDict {
    ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];
    ImageShare* imageShare = [clipboardShare imageShare];
    NSMutableDictionary* clipboardMacroDict =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:

     [NSNumber numberWithBool:[clipboardShare isShared]],@"clipboard_is_shared",
     SAFE_STRING([clipboardShare string]), @"clipboard_text",
     [NSNumber numberWithBool:nil!=[clipboardShare image]],@"clipboard_image",
     [imageShare htmlBlock],@"clipboard_image_share",
     NB(YES),@"show_link_text",
     NB(YES),@"show_link_pictures",
     nil];

    return clipboardMacroDict;
}

- (NSMutableDictionary*)textMacroDict {
    TextShare* textShare = [[SharesProvider instance] textShare];
    return
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     SAFE_STRING([textShare text]),kText,
     NB(YES),@"text_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_pictures",
            nil];
}

- (NSMutableDictionary*)picturesMacroDict {
    return
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     NB(YES),@"pictures_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_text",
     nil];
}

@end