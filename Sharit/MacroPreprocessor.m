//
//  GeneralResponse.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Global.h"
#import "MacroPreprocessor.h"
#import "TemplateLoader.h"

@interface MacroPreprocessor() 
@property (nonatomic,assign) BOOL isComment;
@property (nonatomic,assign) BOOL ifCounter;
@end

@implementation MacroPreprocessor
@synthesize loader=_loader;
@synthesize templateText = _templateText;
@synthesize templateName = _templateName;
@synthesize macroDict;
@synthesize isComment;
@synthesize ifCounter;

- (id) initWithLoader:(NSObject<TemplateLoader>*)loader templateName:(NSString*)templateName macroDictionary:(NSDictionary*)macroDictionary {
    self = [super init];
    self.loader = loader;
    self.templateName = templateName;
    self.templateText = [loader templateTextForTemplateName:templateName];
    self.macroDict = macroDictionary;
    return self;
}

- (id) initWithTemplateText:(NSString*)templateText macroDictionary:(NSDictionary*)macroDictionary {
    self = [super init];
    self.templateText = templateText;
    self.macroDict = macroDictionary;
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
    if (![self.templateText length] && [self.templateName length] && self.loader) {
        self.templateText = [self.loader templateTextForTemplateName:self.templateName];
    }
    NSMutableString* result = [self.templateText mutableCopy];
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

+ (NSString*) f_to_int_s:(CGFloat)f {
    return [NSString stringWithFormat:@"%.0f",f];
}

@end