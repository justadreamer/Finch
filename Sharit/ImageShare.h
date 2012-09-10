//
//  ImageShare.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Share.h"

typedef enum {
    ImageSize_Actual,
    ImageSize_Small,
    ImageSize_Medium,
    ImageSize_Large,
    ImageSize_Thumb
} ImageSizeType;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
static CGFloat constraints[] = {
    0,      // actual
    200,    // small
    400,    // medium
    800     // large
};

static NSDictionary* sizeTypeDict;
#pragma clang diagnostic pop

@interface ImageShare : Share
@property (nonatomic,strong) UIImage* image;

- (NSString*) htmlBlock;
- (NSData*)dataForSizeParam:(NSString*)param;
- (UIImage*)imageForSizeType:(ImageSizeType)sizeType;
- (CGSize)sizeForImageSizeType:(ImageSizeType)sizeType;
@end