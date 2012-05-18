//
//  Share.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Share.h"

@implementation Share
@synthesize isShared;
@synthesize name;

- (NSString*) detailsDescription {
    return nil;
}

- (id) init {
    if ((self = [super init])) {
        self.isShared = YES;
    }
    return self;
}
@end
