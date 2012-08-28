//
//  PicturesShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Global.h"
#import "GlobalDefaults.h"
#import "PicturesShare.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetShare.h"
#import "BasicTemplateLoader.h"
#import "Helper.h"
#import "MacroPreprocessor.h"

@interface PicturesShare()
@property(nonatomic,strong) NSMutableArray* assetShares;
@property(nonatomic,strong) ALAssetsLibrary* library;
@end

@implementation PicturesShare
@synthesize assetShares;
@synthesize library;

- (id) init {
    if ((self = [super init])) {
        self.name = @"Pictures";
        self.library = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void) refresh {
    self.assetShares = [NSMutableArray array];
    __block NSUInteger assetCounter = 0;
    BasicTemplateLoader* loader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:templateExt];
    MacroPreprocessor* macroPreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:@"asset"];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:
     ^(ALAssetsGroup* group, BOOL* stop) {
         [group enumerateAssetsUsingBlock:
          ^(ALAsset* asset,NSUInteger index, BOOL* stop) {
              ALAssetShare* assetShare = [[ALAssetShare alloc] init];
              assetShare.asset = asset;
              assetShare.path = [NSString stringWithFormat:@"/%@?%@=%d",PATH_PREFIX_ASSET, PARAM_ASSET_N,assetCounter];
              assetShare.thumbPath = [NSString stringWithFormat:@"/%@?%@=%d",PATH_PREFIX_ASSET_THUMB, PARAM_ASSET_N,assetCounter++];
              assetShare.macroPreprocessor = macroPreprocessor;
              [self.assetShares addObject:assetShare];
          }];
     }
                              failureBlock:
     ^(NSError* err) {
         VLog(err);
    }];
}

- (NSString*) detailsDescription {
    NSString* desc = @"No images";
    NSInteger count = [self.assetShares count];
    if (count) {
        NSString* format = (count > 1) ? @"%d images" : @"%d image";
        desc = [NSString stringWithFormat:format,count];
    }
    return desc;
}

- (NSMutableDictionary*)macrosDict {
    return
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     NB(YES),@"pictures_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_text",
     [self htmlBlock],@"pictures_html_block",
     nil];
}

- (NSString*) htmlBlock {
    NSMutableString* html = [NSMutableString stringWithString:@""];
    for (ALAssetShare* assetShare in assetShares) {
        [html appendString:[assetShare htmlBlock]];
    }
    return html;
}

- (ALAssetShare*) shareForIndex:(NSInteger)index {
    if (index>=0 && index<[self.assetShares count]) {
        return [self.assetShares objectAtIndex:index];
    }
    return nil;
}
@end