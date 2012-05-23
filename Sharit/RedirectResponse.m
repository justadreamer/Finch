//
//  RedirectResponse.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RedirectResponse.h"

@implementation RedirectResponse
@synthesize redirectURI;

- (UInt64)contentLength {
    return 0;
}

- (UInt64)offset {
    return 0;
}

- (void)setOffset:(UInt64)offset {
    
}

- (NSData *)readDataOfLength:(NSUInteger)length {
    return nil;
}

- (BOOL)isDone {
    return YES;
}

- (NSDictionary *)httpHeaders {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.redirectURI,@"Location",nil];
}

- (NSInteger)status {
    return 303;
}
@end
