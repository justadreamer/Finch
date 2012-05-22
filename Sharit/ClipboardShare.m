//
//  ClipboardShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClipboardShare.h"

@implementation ClipboardShare

- (id) init {
    if ((self = [super init])) {
        self.name = @"Clipboard";
    }
    return self;
}

- (NSString*) string {
    return [[UIPasteboard generalPasteboard] string];
}

- (UIImage*) image {
    return [[UIPasteboard generalPasteboard] image];
}

- (NSArray*) images {
    return [[UIPasteboard generalPasteboard] images];
}

- (NSString*) detailsDescription {
    NSInteger strLen = [self.string length];
    NSInteger imageCount = [self.images count];
    BOOL hasText = strLen > 0;
    BOOL hasImages = imageCount > 0;
    BOOL hasImage = self.image != nil;
    NSString* desc = @"empty";
    if (hasText || hasImages || hasImage) {
        desc = @"";
        if (hasText) {
            int maxLen = 40;
            BOOL isShort = maxLen > strLen;
            NSString* format = isShort ? @"text: %@" : @"text: %@...";
            maxLen = isShort ? strLen : maxLen;
            desc = [desc stringByAppendingFormat:format,[self.string substringToIndex:maxLen]];
            if (hasImages|| hasImage) {
                desc = [desc stringByAppendingString:@" and"];
            }
        }
        if (hasImages) {
            desc = [desc stringByAppendingFormat:@"%d images",imageCount];
        } else if (hasImage) {
            desc = [desc stringByAppendingString:@"1 image"];
        }
    }
    return desc;
}

- (void) updateString:(NSString*)string {
    [[UIPasteboard generalPasteboard] setString:string];
}

@end