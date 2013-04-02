//
//  TemplateLoader.h
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TemplateLoader <NSObject>
- (NSString*) templateTextForTemplateName:(NSString*)templateName;
@end