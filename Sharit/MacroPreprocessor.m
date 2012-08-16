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
@property (nonatomic,assign) BOOL ifCounter;
@property (nonatomic,assign) NSUInteger falseConditionalStart;
@property (nonatomic,strong) NSMutableString* result;
@property (nonatomic,assign) NSRange range;
@end

@implementation MacroPreprocessor
@synthesize loader=_loader;
@synthesize templateText = _templateText;
@synthesize templateName = _templateName;
@synthesize macroDict;
@synthesize ifCounter;
@synthesize falseConditionalStart;
@synthesize result;
@synthesize range;

- (id) initWithLoader:(NSObject<TemplateLoader>*)loader templateName:(NSString*)templateName macroDictionary:(NSDictionary*)macroDictionary {
    self = [super init];
    self.loader = loader;
    self.templateName = templateName;
    self.templateText = [loader templateTextForTemplateName:templateName];
    self.macroDict = macroDictionary;
    return self;
}

- (id) initWithLoader:(NSObject<TemplateLoader>*)loader templateName:(NSString*)templateName {
    self = [super init];
    self.loader = loader;
    self.templateName = templateName;
    self.templateText = [loader templateTextForTemplateName:templateName];
    return self;
}

- (id) initWithTemplateText:(NSString*)templateText macroDictionary:(NSDictionary*)macroDictionary {
    self = [super init];
    self.templateText = templateText;
    self.macroDict = macroDictionary;
    return self;
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


- (NSString*) macroReplacement:(NSString*)macro {
    NSString* replacement = nil;
    NSString* macroName = [self macroName:macro];
    replacement = [self.macroDict objectForKey:macroName];
    return SAFE_STRING(replacement);
}

- (void) shiftRange {
    range.location+=range.length;
    [self adjustRangeLength];
}

- (void) adjustRangeLength {
    range.length = [result length]-range.location;
}

- (void) replaceWith:(NSString*)s {
    [result replaceCharactersInRange:range withString:s];
    range.location += [s length];
    [self adjustRangeLength];
}

- (NSString*) process {
    if (![self.templateText length] && [self.templateName length] && self.loader) {
        self.templateText = [self.loader templateTextForTemplateName:self.templateName];
    }
    self.result = [self.templateText mutableCopy];
    self.ifCounter = 0;
    self.falseConditionalStart = NSNotFound;

    if ([self.result length]) {
        NSString* macroRegex = @"%[^%]*%";
        range = NSMakeRange(0, [self.result length]);
        while (range.location != NSNotFound && range.length > 0) {
            range = [result rangeOfString:macroRegex options:NSRegularExpressionSearch range:range];
            if (range.location == NSNotFound)
                break;
            NSString* macro = [result substringWithRange:range];
            NSString* macroName = [self macroName:macro];
            
            if (self.falseConditionalStart!=NSNotFound) {
                BOOL needShift = YES;
                if ([macroName isEqualToString:@"if"]) {
                    self.ifCounter++;
                } else if ([macroName isEqualToString:@"endif"]) {
                    self.ifCounter--;
                    if (self.ifCounter==0) {
                        range = NSMakeRange(self.falseConditionalStart, range.location+range.length-self.falseConditionalStart);
                        [self replaceWith:@""];
                        self.falseConditionalStart = NSNotFound;
                        needShift = NO;
                    }
                }
                if (needShift) {
                    [self shiftRange];
                }
            } else {
                if ([macroName isEqualToString:@"if"]) {
                    NSObject* macroObj = [self.macroDict objectForKey:[self macroValue:macro]];
                    
                    BOOL isCondFalse = !macroObj ||
                    [macroObj isKindOfClass:[NSNull class]] ||
                    ([macroObj isKindOfClass:[NSNumber class]] && ![(NSNumber*)macroObj boolValue]);
                    
                    if (isCondFalse) {
                        self.falseConditionalStart = range.location;
                        self.ifCounter++;
                        [self shiftRange];
                    } else {
                        [self replaceWith:@""];
                    }
                } else if ([macroName isEqualToString:@"endif"]) {
                    [self replaceWith:@""];
                } else {
                    NSString* replacement = [self macroReplacement:macro];
                    [self replaceWith:replacement];
                }
            }
        }
    }
    return result;
}

+ (NSString*) f_to_int_s:(CGFloat)f {
    return [NSString stringWithFormat:@"%.0f",f];
}

@end