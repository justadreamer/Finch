//
//  UIImage+Additions.h
//  ChimeInApp
//
//  Created by Oleg Kovtun on 13.04.12.
//  Copyright (c) 2012 UberMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONE_RETINA_SIZE (CGSize){960,640}

@interface UIImage (Additions)

- (UIImage*)scaleToSize:(CGSize)mSize;
- (CGSize)sizeProportionallyScaledToSize:(CGSize)mSize;
- (UIImage*)proportionalScaleToSize:(CGSize)size;
- (BOOL)isBiggerThanSize:(CGSize)mSize;

- (UIImage *)fixOrientation;

- (UIImage*)crop:(CGRect)cropRect;

@end
