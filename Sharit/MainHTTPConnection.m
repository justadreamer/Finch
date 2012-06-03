//
//  SharesHTTPConnection.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainHTTPConnection.h"
#import "SharesMacroPreprocessor.h"
#import "HTTPDataResponse.h"
#import "HTTPRedirectResponse.h"

#import "SharesProvider.h"
#import "ClipboardShare.h"
#import "Global.h"
#import "HTTPMessage.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "GlobalDefaults.h"

@interface MainHTTPConnection ()
@property (nonatomic,strong) NSArray* imagePaths;
@property (nonatomic,strong) NSArray* supportedPaths;
@end

@implementation MainHTTPConnection
@synthesize imagePaths;
@synthesize supportedPaths;

- (id) initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
    if ((self = [super initWithAsyncSocket:newSocket configuration:aConfig])) {
        self.imagePaths = [NSArray arrayWithObjects:[GlobalDefaults clipboardImageSrc],[GlobalDefaults clipboardThumbImageSrc], nil];
        NSArray* otherPaths = [NSArray arrayWithObjects:@"/",@"/index.html", nil];
        self.supportedPaths =  [otherPaths arrayByAddingObjectsFromArray:imagePaths];
    }
    return self;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    if ([supportedPaths containsObject:path]) {
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
    SharesMacroPreprocessor* preprocessor = [[SharesMacroPreprocessor alloc] init];
    NSData* response = [[preprocessor process] dataUsingEncoding:NSUTF8StringEncoding];
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

- (HTTPRedirectResponse*) redirectResponse:(NSString*)redirectURI {
    HTTPRedirectResponse* response = [[HTTPRedirectResponse alloc] initWithPath:redirectURI];
    return response;
}

- (BOOL) isIndexPath:(NSString*)path {
    return [path isEqualToString:@"/"] || [path isEqualToString:@"/index.html"];
}

- (HTTPDataResponse*) imageResponse:(NSString*)path {
    NSData* imageData = nil;
    ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];
    if ([path isEqualToString:[GlobalDefaults clipboardImageSrc]]) {
        imageData = UIImagePNGRepresentation([clipboardShare image]);
    } else if ([path isEqualToString:[GlobalDefaults clipboardThumbImageSrc]]) {
        imageData = UIImagePNGRepresentation([clipboardShare thumb]);
    }
    HTTPDataResponse* response = [[HTTPDataResponse alloc] initWithData:imageData];
    return response;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if ([supportedPaths containsObject:path]) {
        if ([method isEqualToString:@"POST"]) {
            [self processRequestData];
            return [self redirectResponse:@"/index.html"];
        } else if ([method isEqualToString:@"GET"]) {            
            if ([self isIndexPath:path]) {
                return [self indexResponse:path];
            } else if ([imagePaths containsObject:path]) {
                return [self imageResponse:path];
            }
        }
    }

    return [super httpResponseForMethod:method URI:path];
}

@end
