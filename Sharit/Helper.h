//
//  Helper.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+ (Helper*) instance;

+ (NSArray*) interfaces;

- (NSArray*) versions;
- (NSString*) baseTemplatesFolder;
- (NSString*) baseDocrootFolder;
- (NSString*) docrootFolder;
- (NSString*) templatesFolder;
- (NSString*) documentsRoot;


@end
