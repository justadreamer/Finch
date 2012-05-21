//
//  SharesHTTPConnection.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharesHTTPConnection.h"
#import "SharesResponseFormatter.h"
#import "HTTPDataResponse.h"

@interface SharesHTTPConnection () 
@property (nonatomic,strong) NSArray* supportedPaths;
@property (nonatomic,strong) SharesResponseFormatter* responseFormatter;
@end

@implementation SharesHTTPConnection
@synthesize supportedPaths;
@synthesize responseFormatter;

- (id) initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
    if ((self = [super initWithAsyncSocket:newSocket configuration:aConfig])) {
        self.supportedPaths = [NSArray arrayWithObjects:@"/",@"/index.html",nil];
        self.responseFormatter = [[SharesResponseFormatter alloc] init];
    }
    return self;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
	if ([method isEqualToString:@"GET"]) {
		if ([self.supportedPaths containsObject:path]) {
			return YES;
		}
	} else if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/index.html"]) {
        return requestContentLength < 65535;
    }
	return [super supportsMethod:method atPath:path];
}

- (void)processBodyData:(NSData *)postDataChunk {
	[(id)request appendData:postDataChunk];
}


- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if ([method isEqualToString:@"GET"]) {
        if ([self.supportedPaths containsObject:path]) {
            NSData* response = [[self.responseFormatter connection:self responseForPath:path] dataUsingEncoding:NSUTF8StringEncoding];
            return [[HTTPDataResponse alloc] initWithData:response];
        }
    } else if ([method isEqualToString:@"POST"]) {
        NSData *postData = [(id)request body];
        
        HTTPDataResponse* response = [[HTTPDataResponse alloc] initWithData:nil];
    }
    return [super httpResponseForMethod:method URI:path];
}

@end
