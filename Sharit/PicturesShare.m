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
@property(nonatomic,strong) NSMutableDictionary* assetSharesMap;
@end

@implementation PicturesShare
@synthesize assetShares;
@synthesize library;
@synthesize assetSharesMap;

- (id) init {
    if ((self = [super init])) {
        self.name = @"Pictures";
        self.library = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void) refresh {
    srand(time(NULL));
    self.assetShares = [NSMutableArray array];
    self.assetSharesMap = [NSMutableDictionary dictionary];
    BasicTemplateLoader* loader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:templateExt];
    MacroPreprocessor* macroPreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:@"asset"];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:
     ^(ALAssetsGroup* group, BOOL* stop) {
         [group enumerateAssetsUsingBlock:
          ^(ALAsset* asset,NSUInteger index, BOOL* stop) {
              if (asset && [asset thumbnail]) {
                  ALAssetShare* assetShare = [[ALAssetShare alloc] init];
                  assetShare.asset = asset;
                  NSString* assetId = [[[[asset defaultRepresentation] url] absoluteString] MD5Hash];
                  [self.assetSharesMap setObject:assetShare forKey:assetId];
                  assetShare.path = [NSString stringWithFormat:@"/%@%@%@",PATH_PREFIX_ASSET, assetId,ASSET_EXT];
                  assetShare.macroPreprocessor = macroPreprocessor;
                  [self.assetShares addObject:assetShare];
              }
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

- (NSDictionary*)specificMacrosDict {
    return
    [NSDictionary dictionaryWithObjectsAndKeys:
     NB(self.isShared),@"pictures_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_text",
     self.isShared ? [self htmlBlock] : @"",@"pictures_html_block",
     nil];
}

- (NSString*) htmlBlock {
    NSMutableString* html = [NSMutableString stringWithString:@""];
    for (ALAssetShare* assetShare in assetShares) {
        [html appendString:[assetShare htmlBlock]];
    }
    return html;
}

- (ALAssetShare*) shareForPath:(NSString*)path {
    NSString* prefix = [path contains:PATH_PREFIX_ASSET_THUMB] ? PATH_PREFIX_ASSET_THUMB : PATH_PREFIX_ASSET;
    NSString* assetId = [path substringBetweenFirst:prefix andSecond:ASSET_EXT];
    return [self.assetSharesMap objectForKey:assetId];
}

@end