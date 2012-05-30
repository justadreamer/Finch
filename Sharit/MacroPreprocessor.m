//
//  GeneralResponse.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MacroPreprocessor.h"
#import "Helper.h"
@interface MacroPreprocessor() 
@property (nonatomic,strong) NSString* templateName;
@property (nonatomic,strong) NSDictionary* macroDict;
@property (nonatomic,assign) BOOL isComment;
@property (nonatomic,assign) BOOL ifCounter;
@end

@implementation MacroPreprocessor
@synthesize templateName;
@synthesize macroDict;
@synthesize isComment;
@synthesize ifCounter;

- (id) initWithTemplateName:(NSString *)_templateName macroDictionary:(NSDictionary *)_dict {
    self = [super init];
    self.templateName = _templateName;
    self.macroDict = _dict;
    return self;
}

- (NSString*) replaceMacro:(NSString*)macro {
    NSString* replacement = nil;
    NSString* macroName = [self macroName:macro];
    if ([macroName isEqualToString:@"if"]) {
        replacement = @"";
        NSObject* macroObj = [self.macroDict objectForKey:[self macroValue:macro]];
        
        BOOL isCondFalse = !macroObj || 
            [macroObj isKindOfClass:[NSNull class]] ||
            ([macroObj isKindOfClass:[NSNumber class]] && ![(NSNumber*)macroObj boolValue]);
        
        if (!self.isComment && isCondFalse) {
            self.isComment = YES;
            self.ifCounter++;
            replacement = @"<!--";
        } else if (self.isComment) {
            self.ifCounter++;
        }
    } else if ([macroName isEqualToString:@"endif"]) {
        replacement = @"";
        if (self.isComment) {
            if (self.ifCounter==1) {
                replacement = @"-->";
            }
            self.ifCounter--;
            if (self.ifCounter==0) {
                self.isComment = NO;
            }
        }
    } else {
        replacement = [self.macroDict objectForKey:macroName];
    }
    return SAFE_STRING(replacement);
}

- (NSString*) templateTextForTemplateName:(NSString*)_templateName {
    NSString* templateText = @"";
    if ([_templateName length]) {
        NSString* templateFullName = [_templateName stringByAppendingFormat:@".%@",[Helper templateExt]];
        NSString* path = [[[Helper instance] templatesFolder] stringByAppendingPathComponent:templateFullName];
        NSError* error = nil;
        templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            VLog(error);
        }
    }
    return templateText;
}

- (NSString*) processMacrosInTemplate:(NSString*)_templateName {
    NSString* templateText = [self templateTextForTemplateName:_templateName];
    NSMutableString* result = [templateText mutableCopy];
    NSInteger length = [result length];
    if (length) {
        NSString* macroRegex = @"%[^%]*%";
        NSRange range = NSMakeRange(0, length);
        while (range.location != NSNotFound && range.length > 0) {
            range = [result rangeOfString:macroRegex options:NSRegularExpressionSearch range:range];
            if (range.location != NSNotFound) {
                NSString* macro = [result substringWithRange:range];
                NSString* replacement = [self replaceMacro:macro];
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

- (NSString*) macroComponent:(NSString*)macro last:(BOOL)last {
    NSString* component = nil;
    NSString* macroContent = [self macroContent:macro];
    NSArray* components = [macroContent componentsSeparatedByString:@" "];
    if ([components count]>0) {
        component = last ? [components lastObject] : [components objectAtIndex:0];
    }
    return component;
}

- (NSString*) macroContent:(NSString*)macro {
    return [macro stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"%"]];    
}

- (NSString*) macroName:(NSString*)macro {
    NSString* macroName = [self macroComponent:macro last:NO];
    return SAFE_STRING(macroName);
}

- (NSString*) macroValue:(NSString*)macro {
    NSString* macroValue = [self macroComponent:macro last:YES];
    return SAFE_STRING(macroValue);
}

- (NSString*) process {
    return [self processMacrosInTemplate:self.templateName];
}

- (NSString*) f_to_int_s:(CGFloat)f {
    return [NSString stringWithFormat:@"%.0f",f];
}

@end