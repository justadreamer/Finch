//
//  NSObject+JSON.m
//  components
//
//  Created by Alex Antonyuk on 12/4/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NSObject+JSON.h"

// id
@implementation NSObject (JSON)

- (NSString *)
JSONRepresentation
{
	if ([NSJSONSerialization isValidJSONObject:self]) {
		NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
		NSString* JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		return JSONString;
	} else {
		return @"";
	}
}

- (NSString *)
prettyJSONRepresentation
{
	if ([NSJSONSerialization isValidJSONObject:self]) {
		NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
		NSString* JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		return JSONString;
	} else {
		return @"";
	}
}

@end


// NSString
@implementation NSString (JSON)

- (id)
JSONValue
{
	NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
	return [data JSONValue];
}

@end

// NSData
@implementation NSData (JSON)

- (id)
JSONValue
{
	NSError* error;
	id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
	if (error) {
		NSLog(@"JSON Error %@", error.localizedDescription);
	}
	return obj;
}

@end