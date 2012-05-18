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
    BOOL hasText = [self.string length]>0;
    BOOL hasImages = [self.images count]>0;
    BOOL hasImage = self.image != nil;
    NSString* desc = @"Clipboard is empty";
    if (hasText || hasImages || hasImage) {
        desc = @"Clipboard has ";
        if (hasText) {
            desc = [desc stringByAppendingString:@"text"];
            if (hasImages|| hasImage) {
                desc = [desc stringByAppendingString:@" and"];
            }
        }
        if (hasImages) {
            desc = [desc stringByAppendingString:@"images"];
        } else if (hasImage) {
            desc = [desc stringByAppendingString:@"image"];
        }
    }
    return desc;
}
@end
