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
    ImageSize_Large
} ImageSizeType;

@interface ImageShare : Share
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) NSString* path;

- (NSString*)htmlBlock;
- (NSData*)dataForSizeParam:(NSString*)param;
@end