//
//  Share.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MacroPreprocessor;
@protocol TemplateLoader;

@interface Share : NSObject
@property (nonatomic,assign) BOOL isShared;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) BOOL isUpdated;
@property (nonatomic,strong) NSString* path;
@property (nonatomic,strong) MacroPreprocessor* macroPreprocessor;

- (NSString*) detailsDescription;
- (BOOL)isDetailsDescriptionAWarning;

- (id) initWithMacroPreprocessor:(MacroPreprocessor*)macroPreprocessor;
- (NSMutableDictionary*)macrosDict;
- (void)processRequestData:(NSDictionary*)requestDict;
- (NSDictionary*)specificMacrosDict;
@end