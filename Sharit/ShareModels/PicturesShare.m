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
#import <CoreLocation/CoreLocation.h>

#import "ALAssetShare.h"
#import "BasicTemplateLoader.h"
#import "Helper.h"
#import "MacroPreprocessor.h"
#import "AlbumShare.h"

@interface PicturesShare()
@property(nonatomic,strong) ALAssetsLibrary* library;
@property(nonatomic,strong) NSMutableDictionary* assetSharesMap;
@property(nonatomic,strong) NSString* localizedFailureReason;
@end

@implementation PicturesShare

- (id) init {
    if ((self = [super init])) {
        self.name = @"Pictures";
        self.library = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void) refresh {
    srand(time(NULL));
    _assetShares = [NSMutableArray array];
    _albumShares = [NSMutableArray array];

    self.assetSharesMap = [NSMutableDictionary dictionary];
    BasicTemplateLoader* loader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:templateExt];
    MacroPreprocessor* picturePreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:@"asset"];
    MacroPreprocessor* videoPreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:@"video"];
    
    __block BOOL groupsDone = NO;
    __block BOOL assetsDone = NO;
    __block NSInteger groupIndex = 0;

    __weak PicturesShare* safeSelf = self;
    

    [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:
     ^(ALAssetsGroup* group, BOOL* stop) {
         //we have enumerated all groups
         if (!group) {
             groupsDone = YES;
             if (assetsDone) {
                 [safeSelf refreshFinished];
             }
         } else {
             AlbumShare* albumShare = [[AlbumShare alloc] initWithAssetsGroup:group];
             albumShare.path = [NSString stringWithFormat:@"albumShare%d",groupIndex++];
             NSInteger numberOfAssets = group.numberOfAssets;
             [_albumShares addObject:albumShare];
             
             [group enumerateAssetsUsingBlock:
              ^(ALAsset* asset,NSUInteger index, BOOL* stop) {
                  if (asset && [asset thumbnail]) {
                      BOOL isVideo = [ALAssetShare isAssetVideo:asset];
                      
                      NSString* filename = [[asset defaultRepresentation] filename];
                      
                      ALAssetShare* assetShare = [self.assetSharesMap objectForKey:filename];
                      
                      //in order to not create duplicates:
                      if (!assetShare) {
                          assetShare = [[ALAssetShare alloc] init];
                          assetShare.parentShare = safeSelf;
                          assetShare.asset = asset;
                          assetShare.path = [NSString stringWithFormat:@"%@%@",PATH_PREFIX_ASSET,filename];
                          assetShare.isVideo = isVideo;
                          assetShare.macroPreprocessor = isVideo ? videoPreprocessor : picturePreprocessor;
                          assetShare.fileName = filename;
                          [assetShare readPrivacyPreference];
                          [self.assetShares addObject:assetShare];
                          [self.assetSharesMap setObject:assetShare forKey:filename];
                      }
                      
                      [albumShare addAssetShare:assetShare];
                      if (index==numberOfAssets-1) {
                          [albumShare sortAssets];
                      }
                  } else if (!asset) {//we have finished enumerating assets
                      assetsDone = YES;
                      if (groupsDone) {
                          [safeSelf refreshFinished];
                      }
                  }
              } ];
         }
     }
                              failureBlock:
     ^(NSError* error) {
         [safeSelf refreshFinishedWithError:error];
    }];
}

- (void) refreshFinished {
    [self refreshFinishedWithError:nil];
}

- (void) refreshFinishedWithError:(NSError*)error {
    [[self class] sortAssetSharesArray:_assetShares];
    if (self.onRefreshFinished) {
        self.onRefreshFinished(error);
    }
    self.localizedFailureReason = [error.userInfo objectForKey:@"NSLocalizedFailureReason"];
}

- (NSString*) detailsDescription {
    NSString* desc = @"No images";
    if (!self.localizedFailureReason) {
        NSInteger count = [self.assetShares count];
        if (count) {
            NSString* format = (count > 1) ? @"%d images, %d private" : @"%d image, %d private";
            desc = [NSString stringWithFormat:format,count,[self numberOfPrivatePictures]];
        }
    } else {
        desc = self.localizedFailureReason;
    }
    return desc;
}

- (BOOL)isDetailsDescriptionAWarning {
    return nil!=self.localizedFailureReason;
}

- (NSDictionary*)specificMacrosDict {
    return
    [NSDictionary dictionaryWithObjectsAndKeys:
     NB(self.isShared),@"pictures_is_shared",
     NB(YES),@"show_link_pasteboard",
     NB(YES),@"show_link_text",
     self.isShared ? [self htmlBlock] : @"",@"pictures_html_block",
     NB(self.isShared && ![self isDetailsDescriptionAWarning]),@"is_warning_shown",
     nil];
}

- (NSString*) htmlBlock {
    NSMutableString* html = [NSMutableString stringWithString:@""];
    for (ALAssetShare* assetShare in _assetShares) {
        if ([assetShare isShared]) {
            [html appendString:[assetShare htmlBlock]];
        }
    }
    return html;
}

- (ALAssetShare*) shareForPath:(NSString*)path {
    path = [path substringAfter:PATH_PREFIX_ASSET];
    ALAssetShare* share = [self.assetSharesMap objectForKey:path];
    return share;
}

- (NSInteger) numberOfPrivatePictures {
    return [[self class] numberOfPrivatePicturesInAssetSharesArray:_assetShares];
}

+ (NSInteger) numberOfPrivatePicturesInAssetSharesArray:(NSArray*)assetShares {
    NSInteger number = 0;
    for (ALAssetShare* asset in assetShares) {
        if (asset.isPrivate) {
            number++;
        }
    }
    return number;
}

+ (void) sortAssetSharesArray:(NSMutableArray*)assetShares {
    NSSortDescriptor* desc = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    [assetShares sortUsingDescriptors:@[desc]];
}

@end