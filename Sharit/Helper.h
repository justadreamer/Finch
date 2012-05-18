//
//  Helper.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+ (NSArray*) interfaces;
+ (UInt16) port;
+ (Helper*) instance;
+ (NSString*) templatesFolderName;
+ (NSString*) templateExt;
- (NSString*) documentsFolder;
- (NSString*) templatesFolder;
- (NSString*) documentsRoot;
@end
