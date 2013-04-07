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
    BasicTemplateLoader* loader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] defaultExtension:templateExt];

    MacroPreprocessor* indexPrerprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:TEMPLATE_INDEX];
    MacroPreprocessor* picturePreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:TEMPLATE_ASSET];
    MacroPreprocessor* videoPreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:TEMPLATE_VIDEO];
    MacroPreprocessor* albumListPreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:TEMPLATE_ALBUM_LIST_ITEM];
    
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
             albumShare.macroPreprocessor = indexPrerprocessor;
             albumShare.macroPreprocessorForList = albumListPreprocessor;
             albumShare.path = [NSString stringWithFormat:@"%@%d",PATH_PREFIX_ALBUM,groupIndex++];
             albumShare.parent = safeSelf;
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
    @{
        @"pictures_is_shared":@(self.isShared),
        @"show_link_pasteboard":@(YES),
        @"show_link_text":@(YES),
        @"album_list_html_block":self.isShared ? [self albumListHtmlBlock] : @"",
        @"warning":     SAFE_STRING(self.localizedFailureReason),
        @"is_warning_shown":@(self.isShared && [self isDetailsDescriptionAWarning])
      };
}

- (NSString*) albumListHtmlBlock {
    NSMutableString* html = [NSMutableString stringWithString:@""];
    for (AlbumShare* albumShare in _albumShares) {
        if ([albumShare isShared]) {
            [html appendString:[albumShare htmlBlockForList]];
        }
    }
    return html;
}

- (Share*) shareForPath:(NSString*)path {
    Share* share = nil;
    if ([path contains:PATH_PREFIX_ALBUM]) {
        path = [path substringAfter:PATH_PREFIX_ALBUM];
        BOOL isPoster = [path contains:PATH_SUFFIX_POSTER];
        if (isPoster) {
            path = [path substringBefore:PATH_SUFFIX_POSTER];
        }
        NSInteger index = [path integerValue];
        share = [self.albumShares objectAtIndex:index];
        if (isPoster) {
            share = [(AlbumShare*)share posterImageShare];
        }
    } else if ([path contains:PATH_PREFIX_ASSET]) {
        path = [path substringAfter:PATH_PREFIX_ASSET];
        share = [self.assetSharesMap objectForKey:path];
    }
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

- (UIImage*)thumbnailShared {
    return [UIImage imageNamed:@"icon-photo-active"];
}

- (UIImage*)thumbnailNotShared {
    return [UIImage imageNamed:@"icon-photo-inactive"];
}

- (BOOL) needsSiblingDetails {
    return YES;
}

- (NSString*)detailsForHTML {
    NSInteger nAlbums = [_albumShares count];
    NSMutableString* s = [NSMutableString stringWithFormat:@"%d photo album",nAlbums];
    if (nAlbums>1)
        [s appendString:@"s"];
    return s;
}

@end