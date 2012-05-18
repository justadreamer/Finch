//
//  ResponseDelegate.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPConnection;

@protocol ResponseFormatterDelegate <NSObject>
- (NSString*) connection:(HTTPConnection*)connection responseForPath:(NSString*)path;
@end
