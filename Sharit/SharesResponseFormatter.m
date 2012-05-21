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
@interface SharesResponseFormatter ()
@property (nonatomic,assign) BOOL isInsideComment;
@end

@implementation SharesResponseFormatter
@synthesize isInsideComment;

- (NSString*) connection:(HTTPConnection*)connection responseForPath:(NSString*)path {
    return [self processMacrosInTemplate:@"index"];
}

- (NSString*) replaceMacro:(NSString *)macro {
    NSString* clipboard = @"clipboard";

    NSString* replacement = @"";
    ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];

    if ([macro contains:@"%if"]) {
        if ([macro contains:clipboard]) {
            replacement = clipboardShare.isShared ? @"" : @"<!--";
            self.isInsideComment = !clipboardShare.isShared;
        }
    } else if ([macro contains:@"%endif"]) {
        replacement = self.isInsideComment ? @"-->" : @"";
        self.isInsideComment = NO;
    } else if (!self.isInsideComment) {
        if ([macro contains:clipboard]) {
            replacement = [clipboardShare string];
        }
    }
    return replacement;
}

@end