//
//  TextShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextShare.h"

@implementation TextShare
@synthesize text;
- (id) init {
    if ((self = [super init])) {
        self.name = @"Text";
    }
    return self;
}

- (NSString*) detailsDescription {
    NSString* desc = @"No text";
    NSInteger length = [self.text length];
    if (length) {
        desc = [NSString stringWithFormat:@"Text length: %d",length];
    }
    return desc;
}

- (NSMutableDictionary*)macrosDict {
    return
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     SAFE_STRING([self text]),kText,
     NB(YES),@"text_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_pictures",
     nil];
}

- (void) processRequestData:(NSDictionary *)dict {
    NSString* newText = [dict objectForKey:kText];
    if (newText) {
        [self setText:newText];
    }
}
@end
