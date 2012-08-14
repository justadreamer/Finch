//
//  GeneralResponse.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define fs(x) [MacroPreprocessor f_to_int_s:x]
@protocol TemplateLoader;
@interface MacroPreprocessor : NSObject
@property (nonatomic,strong) NSDictionary* macroDict;
@property (nonatomic,strong) NSString* templateText;
@property (nonatomic,strong) NSObject<TemplateLoader>* loader;
@property (nonatomic,strong) NSString* templateName;

- (id) initWithLoader:(NSObject<TemplateLoader>*)loader templateName:(NSString*)templateName macroDictionary:(NSDictionary*)macroDictionary;
- (id) initWithLoader:(NSObject<TemplateLoader>*)loader templateName:(NSString*)templateName;

- (id) initWithTemplateText:(NSString*)templateText macroDictionary:(NSDictionary*)macroDictionary;

- (NSString*) process;

//for overriding, inheritance:
- (NSString*) replaceMacro:(NSString*)macro;
- (NSString*) macroName:(NSString*)macro;

+ (NSString*) f_to_int_s:(CGFloat)f;
@end