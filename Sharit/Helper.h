//
//  Helper.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
@property (nonatomic,assign) BOOL isBonjourPublished;
@property (nonatomic,strong) NSString* bonjourName;

+ (Helper*) instance;

- (NSArray*) interfaces;

- (NSArray*) versions;
- (NSString*) baseTemplatesFolder;
- (NSString*) baseDocrootFolder;
- (NSString*) docrootFolder;
- (NSString*) templatesFolder;
- (NSString*) documentsRoot;

- (NSString*) bonjourName;

@end
