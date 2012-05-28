//
//  GeneralResponse.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseFormatterDelegate.h"

@interface ResponseFormatter : NSObject<ResponseFormatterDelegate>
- (NSString*) processMacrosInTemplate:(NSString*)templateName;
- (NSString*) replaceMacro:(NSString*)macro;
- (NSString*) macroName:(NSString*)macro;
@end