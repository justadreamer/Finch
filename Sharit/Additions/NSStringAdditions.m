//
//  NSStringAdditions.m
//  LifelikeClassifieds
//
//  Created by Eugene Dorfman on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSStringAdditions.h"


@implementation NSString (Additions)


- (NSString*) stringByAppendingURLComponent:(NSString*)url {
	if (0==[url length])
		return self;

	const unichar SLASH = '/';
	NSRange range = NSMakeRange(1, [url length]-1);
	NSString* urlToAppend = SLASH == [url characterAtIndex:0] ? [url substringWithRange:range] : url;

	NSString* result;
	if (0==[self length])
		result = urlToAppend;

	if ('/'==[self characterAtIndex:([self length]-1)]) {
		result = [self stringByAppendingString:urlToAppend];
	} else {
		result = [self stringByAppendingFormat:@"/%@",urlToAppend];
	}
	return result;
}

- (NSString*) removeColonFromTimeZone {
	unichar colon = [self characterAtIndex:([self length]-3)];
	if (colon!=':')
		return self;

	NSString* stringToColon = [self substringToIndex:([self length]-3)];
	NSRange rangeAfterColon = NSMakeRange([self length]-2, 2);
	NSString* stringAfterColon = [self substringWithRange:rangeAfterColon];
	NSString* result = [stringToColon stringByAppendingString:stringAfterColon];
	return result;
}

- (NSRange) rangeBetweenFirst:(NSString*)first andSecond:(NSString*)second withinRange:(NSRange)range {
	NSRange rangeBetween = NSMakeRange(NSNotFound, 0);
	if (NSNotFound == range.location || 0 == range.length)
		return rangeBetween;

	NSRange rangeOfFirst = [self rangeOfString:first options:0 range:range];

	if (NSNotFound == rangeOfFirst.location)
		return rangeBetween;

	NSUInteger firstLocation = rangeOfFirst.location+[first length];

	NSRange rangeOfSecond = NSMakeRange(firstLocation, range.length - (firstLocation-range.location));
	if (NSNotFound == rangeOfSecond.location || rangeOfSecond.length<=0)
		return rangeBetween;

	rangeOfSecond = [self rangeOfString:second options:0 range:rangeOfSecond];

	if (NSNotFound == rangeOfSecond.location)
		return rangeBetween;
	rangeBetween = NSMakeRange(firstLocation,rangeOfSecond.location-firstLocation);
	return rangeBetween;
}

- (NSRange) rangeBetweenFirst:(NSString*)first andSecond:(NSString*)second {
	NSRange allRange = NSMakeRange(0, [self length]);
	return [self rangeBetweenFirst:first andSecond:second withinRange:allRange];
}

- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second withinRange:(NSRange)range {
	NSRange rangeBetween = [self rangeBetweenFirst:first andSecond:second withinRange:range];
	if (NSNotFound==rangeBetween.location || 0==rangeBetween.length)
		return nil;
	NSString* between = [self substringWithRange:rangeBetween];
	return between;
}

- (NSString*) substringBetweenFirst:(NSString*)first andSecond:(NSString*)second {
	NSRange allRange = NSMakeRange(0, [self length]);
	return [self substringBetweenFirst:first andSecond:second withinRange:allRange];
}

- (BOOL) isURLImage {
	// search in all vailable images formats
	for (NSString *format in [NSArray arrayWithObjects:@".jpg",@".gif",@".png",@".jpeg",@".bmp",@".tiff",@".ico",nil]) {
		NSRange match = [self rangeOfString: format options:NSCaseInsensitiveSearch];
		if (match.location != NSNotFound) {
			return YES;
		}
	}
	return NO;
}

- (NSString*) substringAfter:(NSString*)after {
	NSString* substr = nil;
	NSRange range = [self rangeOfString:after];
	if (NSNotFound !=range.location && range.length > 0) {
		NSUInteger location = range.location+range.length;
		if (location<[self length]) {
			substr = [self substringFromIndex:location];
		}
	}
	return substr;
}

- (NSString*) substringBefore:(NSString*)before {
	NSString* substr = nil;
	NSRange range = [self rangeOfString:before];
	if (NSNotFound !=range.location && range.length > 0) {
        substr = [self substringToIndex:range.location];
	}
	return substr;
}

- (BOOL)contains:(NSString*)substring {
	NSRange range = [self rangeOfString:substring];
	return NSNotFound!=range.location;
}

- (BOOL) isValidEmail {
	NSRange range = [self rangeOfString:@"[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:NSRegularExpressionSearch];
	return NSNotFound!=range.location;
}

-(int)hexValue{
	int base = 16;
	int result = 0;
	for (int i = 0; i < [self length]; i++){
		unichar c = [self characterAtIndex: i];
		if ((c >= '0') && (c <= '9'))
			result = (result * base) + (c - '0');
		else if ((c >= 'A') && (c <= 'F'))
			result = (result * base) + (c - 'A' + 10);
		else if ((c >= 'a') && (c <= 'f'))
			result = (result * base) + (c - 'a' + 10);
		else
			return result;
	}
	return result;
}

- (NSUInteger)countOccurencesOfString:(NSString*)searchString {
    int strCountLen = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
	int searchCountLen = [searchString length];
	
	NSUInteger occurencesCount = 0;
	if (searchCountLen!=0)
		occurencesCount =  strCountLen / searchCountLen;
	
	return occurencesCount;
}

- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font{
    // Create copy that will be the returned result
    NSMutableString *truncatedString = [[self mutableCopy] autorelease];
    NSString* ellipsis = @"...";
    
    if (width<=0 || !font) {
        return truncatedString;
    }
    
    // Make sure string is longer than requested width
    if ([self sizeWithFont:font].width > width){
        // Accommodate for ellipsis we'll tack on the end
        width -= [ellipsis sizeWithFont:font].width;
        
        // Get range for last character in string
        NSRange range = {truncatedString.length - 1, 1};
        
        // Loop, deleting characters until string fits within width
        while ([truncatedString sizeWithFont:font].width > width) {
            // Delete character at end
            [truncatedString deleteCharactersInRange:range];
            
            // Move back another character
            range.location--;
        }
        
        // Append ellipsis
        [truncatedString replaceCharactersInRange:range withString:ellipsis];
    }
    
    return truncatedString;
}

- (BOOL) containsRange:(NSRange) range {
    BOOL contains = NO;
    if (range.location+range.length<=[self length]) {
        contains = YES;
    }
    return contains;
}

- (NSString*)capitalized1WordString {
    if ([self length] == 0)
        return nil;
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}

- (NSString *)MD5Hash {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15] ];
}
@end