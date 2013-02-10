//
//  HTTPForbiddenResponse.m
//  Finch
//
//  Created by Eugene Dorfman on 2/10/13.
//
//

#import "HTTPForbiddenResponse.h"
@interface HTTPForbiddenResponse ()
@property (nonatomic,strong) NSString* responseString;
@property (nonatomic,assign) UInt64 offset;
@end

@implementation HTTPForbiddenResponse
@synthesize offset = _offset;

- (id) init {
    if (self = [super init]) {
_responseString = @"Forbidden";
    }
    return self;
}

- (UInt64)contentLength {
    return [_responseString length];
}

- (UInt64)offset {
    return _offset;
}

- (void)setOffset:(UInt64)offset {
    _offset = offset;
}

- (NSData *)readDataOfLength:(NSUInteger)length {
    return [_responseString dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)isDone {
    return YES;
}

- (NSInteger) status {
    return 403;
}

@end
