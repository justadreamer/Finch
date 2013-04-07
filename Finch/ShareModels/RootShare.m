//
//  RootShare.m
//  Finch
//
//  Created by Eugene Dorfman on 4/6/13.
//
//

#import "RootShare.h"
#import "PasteboardShare.h"
#import "TextShare.h"
#import "PicturesShare.h"
#import "BasicTemplateLoader.h"
#import "MacroPreprocessor.h"
#import "Helper.h"

@implementation RootShare
- (id) init {
    if (self = [super init]) {
        self.children = [self setupShares];
        for (Share* s in self.children) {
            s.parent = self;
        }
    }
    return self;
}

- (NSMutableArray*) setupShares {
    NSMutableArray* _shares = [NSMutableArray array];
    BasicTemplateLoader* basicLoader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] defaultExtension:templateExt];
    MacroPreprocessor* macroPreprocessor = [[MacroPreprocessor alloc] initWithLoader:basicLoader templateName:TEMPLATE_INDEX];
    
    Share* clipboard = [[PasteboardShare alloc] initWithMacroPreprocessor:macroPreprocessor];
    [_shares addObject:clipboard];
    
    Share* text = [[TextShare alloc] initWithMacroPreprocessor:macroPreprocessor];
    [_shares addObject:text];
    
    Share* picture = [[PicturesShare alloc] initWithMacroPreprocessor:macroPreprocessor];
    [_shares addObject:picture];
    
    return _shares;
}

@end