//
//  PicturesShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PicturesShare.h"

@implementation PicturesShare
@synthesize images;
- (id) init {
    if ((self = [super init])) {
        self.name = @"Pictures";
    }
    return self;
}

- (NSString*) detailsDescription {
    NSString* desc = @"No images";
    NSInteger count = [self.images count];
    if (count) {
        NSString* format = (count > 1) ? @"%d images" : @"%d image";
        desc = [NSString stringWithFormat:format,count];
    }
    return desc;
}

- (NSMutableDictionary*)macrosDict {
    return
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     NB(YES),@"pictures_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_text",
     nil];
}
@end
