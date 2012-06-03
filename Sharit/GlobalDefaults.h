//
//  GlobalDefaults.h
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalDefaults : NSObject
+ (UInt16) port;

+ (NSString*) templatesFolderName;
+ (NSString*) docrootFolderName;

+ (NSString*) templateExt;
+ (NSString*) clipboardImageSrc;
+ (NSString*) clipboardThumbImageSrc;
@end
