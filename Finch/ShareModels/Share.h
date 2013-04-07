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
#import "SiblingSharesProvider.h"

@interface Share : NSObject<SiblingSharesProvider>
@property (nonatomic,assign) BOOL isShared;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) BOOL isUpdated;
@property (nonatomic,strong) NSString* path;
@property (nonatomic,strong) MacroPreprocessor* macroPreprocessor;
@property (nonatomic,weak) Share* parent;
@property (nonatomic,strong) NSArray* children;

- (NSString*) detailsDescription;
- (NSString*) detailsForHTML;
- (BOOL)isDetailsDescriptionAWarning;

- (id) initWithMacroPreprocessor:(MacroPreprocessor*)macroPreprocessor;
- (NSMutableDictionary*)macrosDict;
- (void)processRequestData:(NSDictionary*)requestDict;
- (NSDictionary*)specificMacrosDict;
- (UIImage*)thumbnail;
- (UIImage*)thumbnailShared;
- (UIImage*)thumbnailNotShared;

- (BOOL)needsSiblingDetails;
- (NSDictionary*)siblingDetailMacroDict;
@end