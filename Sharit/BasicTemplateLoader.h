//
//  BasicTemplateLoader.h
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateLoader.h"
@interface BasicTemplateLoader : NSObject<TemplateLoader>
@property (nonatomic,strong) NSString* templateFolder;
@property (nonatomic,strong) NSString* templateExt;

- (id) initWithFolder:(NSString*)folder templateExt:(NSString*)ext;
@end
