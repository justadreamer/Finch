//
//  SharesResponseFormatter.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharesResponseFormatter.h"
#import "SharesProvider.h"
#import "ClipboardShare.h"
#import "Helper.h"

#define CLIPBOARD @"clipboard"
#define CLIPBOARD_IMAGE @"clipboard_image"

@interface SharesResponseFormatter ()
@property (nonatomic,assign) NSInteger ifCounter;
@property (nonatomic,assign) NSInteger commentLevel;
@property (nonatomic,strong) NSDictionary* clipboardMacroDict;
@end

@implementation SharesResponseFormatter
@synthesize ifCounter;
@synthesize commentLevel;
@synthesize clipboardMacroDict;

- (id) init {
    self = [super init];
    self.commentLevel = -1;
    self.clipboardMacroDict = nil;
    [self setIsInsideComment:NO];
    return self;
}

- (NSDictionary*)clipboardMacroDict {
    if (nil==clipboardMacroDict) {
        ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];
        self.clipboardMacroDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              SAFE_STRING([clipboardShare string]), @"clipboard_text",
                              SAFE_STRING([Helper clipboardImageSrc]),@"clipboard_image_src",
                              [self ftos:[clipboardShare imageSize].width],@"clipboard_image_width",
                              [self ftos:[clipboardShare imageSize].height],@"clipboard_image_height",

                              SAFE_STRING([Helper clipboardThumbImageSrc]),@"clipboard_thumb_image_src",
                              [self ftos:[clipboardShare thumbSize].width],@"clipboard_thumb_image_width",
                              [self ftos:[clipboardShare thumbSize].height],@"clipboard_thumb_image_height",
                     nil];
    }
    return clipboardMacroDict;
}

- (NSString*) connection:(HTTPConnection*)connection responseForPath:(NSString*)path {
    return [self processMacrosInTemplate:@"index"];
}

- (NSString*) ftos:(CGFloat)f {
    return [NSString stringWithFormat:@"%.0f",f];
}

- (NSString*) replaceContentMacro:(NSString*)macro {
    NSString* replacement = nil;
    NSString* macroName = [self macroName:macro];
    if ([macroName contains:CLIPBOARD]) {
        replacement = [self.clipboardMacroDict objectForKey:macroName];
    }
    return replacement;
}
#define NO_COMMENT -1
- (BOOL) isInsideComment {
    return self.commentLevel>NO_COMMENT;
}

- (void) setIsInsideComment:(BOOL)isInsideComment {
    if (isInsideComment) {
        self.commentLevel = self.ifCounter;
    } else {
        self.commentLevel = NO_COMMENT;
    }
}

- (NSString*) openComment:(BOOL)openComment {
    [self setIsInsideComment:openComment];
    return openComment ? @"<!--" : @"";
}

- (NSString*) replaceMacro:(NSString *)macro {
    NSString* replacement = nil;
    ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];

    if ([macro contains:@"%endif"]) {
        replacement = self.commentLevel == self.ifCounter ? @"-->" : @"";
        self.ifCounter--;
    } else if (![self isInsideComment]) {
        if ([macro contains:@"%if"]) {
            self.ifCounter++;
            if ([macro contains:CLIPBOARD_IMAGE]) {
                replacement = [self openComment:![clipboardShare image]];
            } else if ([macro contains:CLIPBOARD]) {
                replacement = [self openComment:!clipboardShare.isShared];          
            }
        } else
            replacement = [self replaceContentMacro:macro];
    }

    return SAFE_STRING(replacement);
}

@end