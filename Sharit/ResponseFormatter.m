//
//  GeneralResponse.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResponseFormatter.h"
#import "Helper.h"

@implementation ResponseFormatter

- (NSString*) connection:(HTTPConnection*)connection responseForPath:(NSString*)path {
    return nil;
}

- (NSString*) templateTextForTemplateName:(NSString*)templateName {
    NSString* templateText = @"";
    if ([templateName length]) {
        NSString* templateFullName = [templateName stringByAppendingFormat:@".%@",[Helper templateExt]];
        NSString* path = [[[Helper instance] templatesFolder] stringByAppendingPathComponent:templateFullName];
        NSError* error = nil;
        templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            VLog(error);
        }
    }
    return templateText;
}

/* Override this method in subclass to replace a specific macro with specific string data (don't forget to call super if you don't have a macro for this*/
- (NSString*) replaceMacro:(NSString*)macro {
    return @"";
}

- (NSString*) processMacrosInTemplate:(NSString*)templateName {
    NSString* templateText = [self templateTextForTemplateName:templateName];
    NSMutableString* result = [templateText mutableCopy];
    NSInteger length = [result length];
    if (length) {
        NSString* macroRegex = @"%[^%]*%";
        NSRange range = NSMakeRange(0, length);
        while (range.location != NSNotFound && range.length > 0) {
            range = [result rangeOfString:macroRegex options:NSRegularExpressionSearch range:range];
            if (range.location != NSNotFound) {
                NSString* replacement = [self replaceMacro:[result substringWithRange:range]];
                [result replaceCharactersInRange:range withString:replacement];
                NSInteger replacementLength = [replacement length];
                length += replacementLength - range.length;
                range.location += replacementLength;
                range.length = length - range.location;
            }
        }
    }
    return result;
}
@end
