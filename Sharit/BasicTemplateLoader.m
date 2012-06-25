//
//  BasicTemplateLoader.m
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
#import "BasicTemplateLoader.h"

@implementation BasicTemplateLoader
@synthesize templateFolder;
@synthesize templateExt;

- (NSString*) templateTextForTemplateName:(NSString*)templateName {
    NSString* templateText = @"";
    if ([templateName length]) {
        NSString* templateFullName = [templateName stringByAppendingFormat:@".%@",self.templateExt];
        NSString* path = [self.templateFolder stringByAppendingPathComponent:templateFullName];
        NSError* error = nil;
        templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            VLog(error);
        }
    }
    return templateText;
}

- (id) initWithFolder:(NSString*)folder templateExt:(NSString*)ext {
    self = [self init];
    self.templateFolder = folder;
    self.templateExt = ext;
    return self;
}

@end