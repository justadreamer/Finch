//
//  GeneralResponse.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MacroPreprocessor : NSObject
- (id) initWithTemplateName:(NSString*)templateName macroDictionary:(NSDictionary*)macroDictionary;
- (NSString*) process;

//for overriding, inheritance:
- (NSString*) replaceMacro:(NSString*)macro;
- (NSString*) macroName:(NSString*)macro;

- (NSString*) f_to_int_s:(CGFloat)f;
@end