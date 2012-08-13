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
#import "ImageShare.h"
#import "TextShare.h"

@interface MainHTTPConnection ()
@property (nonatomic,strong) NSArray* indexPaths;
@property (nonatomic,strong) NSString* redirectPath;
@end

@implementation MainHTTPConnection
@synthesize indexPaths;
@synthesize redirectPath;

- (id) initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
    if ((self = [super initWithAsyncSocket:newSocket configuration:aConfig])) {
        NSArray* paths = [NSArray arrayWithObjects:@"/",@"/index.html",@"/text.html",@"/pictures.html", nil];
        self.indexPaths =  paths;
    }
    return self;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    if ([method isEqualToString:@"GET"]) {
        return YES;
    } else if ([method isEqualToString:@"POST"]) {
        return requestContentLength < 65535;
    }
	return [super supportsMethod:method atPath:path];
}

- (void)processBodyData:(NSData *)postDataChunk {
	[request appendData:postDataChunk];
}

- (HTTPDataResponse*) indexResponse:(NSString*)path {
    SharesMacroPreprocessor* preprocessor = [[SharesMacroPreprocessor alloc] initWithPath:path];
    NSData* response = [[preprocessor process] dataUsingEncoding:NSUTF8StringEncoding];
    return [[HTTPDataResponse alloc] initWithData:response];
}

- (void) processRequestData {
    NSData* postData = [request body];
    NSDictionary* dict = [self parseParams:[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]];
    NSString* clipboard = [dict objectForKey:kClipboard];
    NSString* text = [dict objectForKey:kText];

    if (clipboard) {
        ClipboardShare* share = [[SharesProvider instance] clipboardShare];
        [share updateString:clipboard];
    } else if (text) {
        TextShare* share = [[SharesProvider instance] textShare];
        [share setText:text];
    }
    self.redirectPath = [dict objectForKey:kRedirectPath];
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
    BOOL res = [self.indexPaths containsObject:path];
    return res;
}

- (HTTPDataResponse*) imageResponseForShare:(ImageShare*)share atPath:(NSString*)path {
    NSDictionary* params = [self parseGetParams];
    NSData* imageData = [share dataForSizeParam:[params objectForKey:@"size"]];
    HTTPDataResponse* response = [[HTTPDataResponse alloc] initWithData:imageData];
    return response;
}

- (NSString*) removeParams:(NSString*)path {
    NSArray* components = [path componentsSeparatedByString:@"?"];
    NSString* newPath = path;
    if ([components count]>0) {
        newPath = [components objectAtIndex:0];
    }
    return newPath;
}

- (HTTPDataResponse*) responseForShareAtPath:(NSString*)path {
    SharesProvider* provider = [SharesProvider instance];
    NSString* noParamsPath = [self removeParams:path];
    Share* share = [provider shareForPath:noParamsPath];
    HTTPDataResponse* response = nil;
    if ([share isKindOfClass:[ImageShare class]]) {
        response = [self imageResponseForShare:(ImageShare*)share atPath:path];
    }
    return response;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if ([method isEqualToString:@"POST"]) {
        [self processRequestData];
        NSString* redirect = [self.redirectPath length]? self.redirectPath : @"/index.html";
        self.redirectPath = nil;
        return [self redirectResponse:redirect];
    } else if ([method isEqualToString:@"GET"]) {
        if ([self isIndexPath:path]) {
            return [self indexResponse:path];
        } else {
            return [self responseForShareAtPath:path];
        }
    }

    return [super httpResponseForMethod:method URI:path];
}

@end
