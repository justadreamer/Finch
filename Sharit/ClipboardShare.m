//
//  ClipboardShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClipboardShare.h"
#import "UIImage+Additions.h"
#import "ImageShare.h"
#import "GlobalDefaults.h"

@interface ClipboardShare ()
@end

@implementation ClipboardShare
@synthesize imageShare;

- (id) init {
    if ((self = [super init])) {
        self.name = @"Pasteboard";
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

- (ImageShare*) imageShare {
    if (nil==imageShare) {
        imageShare = [[ImageShare alloc] init];
        imageShare.path = URLClipboardImage;
        imageShare.templateLoader = self.templateLoader;
    }
    imageShare.image = [self image];
    return imageShare;
}

- (NSString*) detailsDescription {
    NSInteger strLen = [self.string length];
    NSInteger imageCount = [self.images count];
    BOOL hasText = strLen > 0;
    BOOL hasImages = imageCount > 1;
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