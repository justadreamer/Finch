//
//  SharesHTTPConnection.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainHTTPConnection.h"
#import "HTTPDataResponse.h"
#import "HTTPRedirectResponse.h"

#import "SharesProvider.h"
#import "PasteboardShare.h"
#import "Global.h"
#import "HTTPMessage.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "GlobalDefaults.h"
#import "ImageShare.h"
#import "TextShare.h"
#import "BasicTemplateLoader.h"
#import "MacroPreprocessor.h"
#import "ALAssetShare.h"
#import "HTTPAsyncAssetResponse.h"
#import "HTTPForbiddenResponse.h"

@interface MainHTTPConnection ()
@property (nonatomic,strong) NSString* redirectPath;
@end

@implementation MainHTTPConnection

- (id) initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
    if ((self = [super initWithAsyncSocket:newSocket configuration:aConfig])){
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

- (HTTPDataResponse*) dataResponseForShare:(Share*)share atPath:(NSString*)path{
    NSMutableDictionary* macroDict = [share macrosDict];
    [macroDict setObject:path forKey:kRedirectPath];
    [share.macroPreprocessor setMacroDict:macroDict];

    NSString* responseString = [share.macroPreprocessor process];

    NSData* response = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    return [[HTTPDataResponse alloc] initWithData:response];
}

- (void) processRequestData:(NSString*)path {
    NSData* postData = [request body];
    NSString* requestBody = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    requestBody = [requestBody stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSDictionary* dict = [self parseParams:requestBody];

    Share* share = [[SharesProvider instance] shareForPath:path andParams:dict];
    if (share.isShared) {
        [share processRequestData:dict];
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

- (NSObject<HTTPResponse>*) imageResponseForShare:(ImageShare*)share atPath:(NSString*)path {
    NSDictionary* params = [self parseGetParams];
    ALAssetShare* assetShare = [share isKindOfClass:[ALAssetShare class]] ? (ALAssetShare*) share : nil;
    NSData* imageData = [share dataForSizeParam:[params objectForKey:@"size"]];
    NSObject<HTTPResponse>* response = nil;
    if (assetShare && assetShare.isVideo && nil==imageData) {
        response = [[HTTPAsyncAssetResponse alloc] initWithAssetRepresentation:assetShare.defaultRepresentation forConnection:self andContentType:@"video/mp4"];
    } else {
        response = [[HTTPDataResponse alloc] initWithData:imageData];
    }
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

- (NSObject<HTTPResponse>*) responseForShareAtPath:(NSString*)path {
    SharesProvider* provider = [SharesProvider instance];
    NSDictionary* params = [self parseGetParams];
    NSString* noParamsPath = [self removeParams:path];
    Share* share = [provider shareForPath:noParamsPath andParams:params];
    NSObject<HTTPResponse> * response = nil;
    if (share) {
        if ([share isShared]) {
            if ([share isKindOfClass:[ImageShare class]]) {
                response = [self imageResponseForShare:(ImageShare*)share atPath:path];
            } else {
                response = [self dataResponseForShare:share atPath:path];
            }
        } else {
            response = [HTTPForbiddenResponse new];
        }
    }
    return response;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if ([method isEqualToString:@"POST"]) {
        [self processRequestData:path];
        NSString* redirect = [self.redirectPath length] ? self.redirectPath : PATH_INDEX;
        self.redirectPath = nil;
        return [self redirectResponse:redirect];
    } else if ([method isEqualToString:@"GET"]) {
        NSObject<HTTPResponse>* response = [self responseForShareAtPath:path];
        if (nil!=response) {
            return response;
        }
    }

    NSObject<HTTPResponse>* response = [super httpResponseForMethod:method URI:path];

    if (nil==response) {
        response = [self responseForShareAtPath:PATH_INDEX];
    }
    return response;
}

@end
