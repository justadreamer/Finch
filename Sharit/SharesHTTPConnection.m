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
#import "SharesProvider.h"
#import "ClipboardShare.h"
#import "Global.h"
#import "HTTPMessage.h"
#import "AppDelegate.h"
#import "RedirectResponse.h"

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
    if ([self.supportedPaths containsObject:path]) {
        if ([method isEqualToString:@"GET"]) {
			return YES;
		} else if ([method isEqualToString:@"POST"]) {
            return requestContentLength < 65535;
        }
    }
	return [super supportsMethod:method atPath:path];
}

- (void)processBodyData:(NSData *)postDataChunk {
	[request appendData:postDataChunk];
}

- (HTTPDataResponse*) indexResponse:(NSString*)path {
    NSData* response = [[self.responseFormatter connection:self responseForPath:path] dataUsingEncoding:NSUTF8StringEncoding];
    return [[HTTPDataResponse alloc] initWithData:response];
}

- (void) processRequestData {
    NSData* postData = [request body];
    NSDictionary* dict = [self parseParams:[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]];
    NSString* clipboard = [dict objectForKey:kClipboard];
    if (clipboard) {
        ClipboardShare* share = [[SharesProvider instance] clipboardShare];
        [share updateString:clipboard];
    }

    dispatch_async(dispatch_get_main_queue(), ^() {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate sharesRefreshed];
    });
}

- (RedirectResponse*) redirectResponse:(NSString*)redirectURI {
    RedirectResponse* response = [[RedirectResponse alloc] init];
    response.redirectURI = redirectURI;
    return response;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if ([self.supportedPaths containsObject:path]) {
        if ([method isEqualToString:@"POST"]) {
            [self processRequestData];
            return [self redirectResponse:@"/index.html"];
        } else if ([method isEqualToString:@"GET"]) {
            return [self indexResponse:path];
        }
    }

    return [super httpResponseForMethod:method URI:path];
}

@end
