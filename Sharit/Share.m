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
@synthesize isUpdated;
@synthesize name;
@synthesize path;
@synthesize templateLoader;

- (NSString*) detailsDescription {
    return nil;
}

- (id) init {
    if ((self = [super init])) {
        self.isShared = YES;
        self.isUpdated = NO;
    }
    return self;
}

- (id) initWithTemplateLoader:(NSObject<TemplateLoader>*) _templateLoader {
    if ((self = [self init])) {
        self.templateLoader = _templateLoader;
    }
    return self;
}

- (NSMutableDictionary*)macrosDict {
    return nil;
}

- (void) processRequestData:(NSDictionary *)dict {
    
}
@end