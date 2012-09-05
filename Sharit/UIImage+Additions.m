//
//  UIImage+Additions.m
//  ChimeInApp
//
//  Created by Oleg Kovtun on 13.04.12.
//  Copyright (c) 2012 UberMedia. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage*)scaleToSize:(CGSize)mSize
{
    UIGraphicsBeginImageContext(mSize);
    [self drawInRect:CGRectMake(0, 0, mSize.width, mSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (CGSize)sizeProportionallyScaledToSize:(CGSize)mSize {
    CGFloat newWidth = 1;
    CGFloat newHeight = 1;
    if (self.size.width > self.size.height) {
        newWidth = mSize.width;
        newHeight = newWidth * (self.size.height / self.size.width);
    } else {
        newHeight = mSize.height;
        newWidth = newHeight * (self.size.width / self.size.height);
        
    }
    return CGSizeMake(newWidth, newHeight);
}

- (UIImage*)proportionalScaleToSize:(CGSize)mSize 
{
    CGSize newSize = [self sizeProportionallyScaledToSize:mSize];
    return [self scaleToSize:newSize];
}

- (BOOL)isBiggerThanSize:(CGSize)mSize
{
    BOOL isBigger = NO;
    if ( self.size.width > mSize.width || self.size.height > mSize.height ) {
        isBigger = YES;
    }
    return isBigger;
}

- (UIImage *)fixOrientation {
    return [self fixOrientationAndScale:1.0];
}

- (UIImage *)fixOrientationAndScale:(CGFloat)scale {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp && scale==1.0) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGSize newSize = CGSizeMake(self.size.width*scale, self.size.height*scale);
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, newSize.width, newSize.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,newSize.height,newSize.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,newSize.width,newSize.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage*)crop:(CGRect)cropRect
{
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image 
    CGRect drawRect = CGRectMake(-cropRect.origin.x, -cropRect.origin.y, self.size.width, self.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    
    // draw image
    [self drawInRect:drawRect];
    
    // grab image
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

@end
