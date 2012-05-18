//
//  NSStringAdditions.h
//  LifelikeClassifieds
//
//  Created by Eugene Dorfman on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString*) stringByAppendingURLComponent:(NSString*)url;
- (NSString*) removeColonFromTimeZone;
- (NSRange) rangeBetweenFirst:(NSString*)first andSecond:(NSString*)second withinRange:(NSRange)range;
- (NSRange) rangeBetweenFirst:(NSString*)first andSecond:(NSString*)second;
- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second withinRange:(NSRange)range;
- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second;
- (BOOL) isURLImage;
- (NSString*) substringAfter:(NSString*)after;
- (NSString*) substringBefore:(NSString*)before;
- (BOOL)contains:(NSString*)substring;
- (BOOL) isValidEmail;
- (int)hexValue;
- (NSUInteger)countOccurencesOfString:(NSString*)searchString;
- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;
- (BOOL) containsRange:(NSRange) range;
@end