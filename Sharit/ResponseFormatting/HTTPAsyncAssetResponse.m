//
//  HTTPAsyncAssetResponse.m
//  Sharit
//
//  Created by Eugene Dorfman on 10/14/12.
//
//

#import "HTTPAsyncAssetResponse.h"
#import "HTTPConnection.h"
@interface HTTPAsyncAssetResponse ()
@property (nonatomic,assign) HTTPConnection* connection;
@property (nonatomic,strong) ALAssetRepresentation* assetRep;
@property (nonatomic,assign) UInt64 offset;
@property (nonatomic,assign) long long size;
@property (nonatomic,assign) BOOL isDone;
@end

@implementation HTTPAsyncAssetResponse
- (id)initWithAssetRepresentation:(ALAssetRepresentation*)assetRep forConnection:(HTTPConnection*)connection andContentType:(NSString*)contentType{
    if ((self = [self init])) {
        _connection = connection;
        _assetRep = assetRep;
        _size = [_assetRep size];
        _headers = [NSMutableDictionary dictionaryWithCapacity:5];
        [_headers setObject:contentType forKey:@"Content-Type"];
        
    }
    return self;
}

- (UInt64)contentLength {
    return _size;
}

- (NSData *)readDataOfLength:(NSUInteger)length {
    NSData* result = nil;
    uint8_t* buffer = malloc(length);
    if (buffer) {
        NSError* error = nil;
        NSUInteger len = [_assetRep getBytes:buffer fromOffset:_offset length:length error:&error];
        if (!error && len) {
            if (len!=length) {
                buffer = realloc(buffer,len);
            }
            result = [NSData dataWithBytesNoCopy:buffer length:len freeWhenDone:YES];
            _offset+=len;
        } else {
            free(buffer);
            VLog(error);
            [_connection responseDidAbort:self];
        }
    }
    return result;
}

- (BOOL)isDone {
    return _offset==_size;
}

- (NSDictionary*) httpHeaders {
    return _headers;
}

- (BOOL) isAsynchronous {
    return YES;
}
@end