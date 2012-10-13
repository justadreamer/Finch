//
//  HTTPAsyncAssetResponse.h
//  Sharit
//
//  Created by Eugene Dorfman on 10/14/12.
//
//

#import <Foundation/Foundation.h>
#import "HTTPResponse.h"

@class HTTPConnection;

@interface HTTPAsyncAssetResponse : NSObject <HTTPResponse>
@property (nonatomic,strong) NSMutableDictionary* headers;
- (id)initWithAssetRepresentation:(ALAssetRepresentation*)assetRep forConnection:(HTTPConnection*)connection andContentType:(NSString*)contentType;
@end
