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

- (NSString*) templateTextForTemplateName:(NSString*)templateName {
    NSString* templateText = @"";
    if ([templateName length]) {
        NSString* path = [_templateFolder stringByAppendingPathComponent:templateName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSString* templateFullName = [templateName stringByAppendingFormat:@".%@",self.templateExt];
            path = [self.templateFolder stringByAppendingPathComponent:templateFullName];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                ALog(@"template does not exist at path: %@", path);
                return nil;
            }
        }

        NSError* error = nil;
        templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            VLog(error);
        }
    }
    return templateText;
}

- (id) initWithFolder:(NSString*)folder defaultExtension:(NSString*)ext {
    self = [self init];
    self.templateFolder = folder;
    self.templateExt = ext;
    return self;
}

@end