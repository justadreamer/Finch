//
//  AlbumShare.m
//  Finch
//
//  Created by Eugene Dorfman on 3/16/13.
//
//

#import "AlbumShare.h"
#import "ALAssetShare.h"
#import "PicturesShare.h"
#import "MacroPreprocessor.h"

@interface AlbumShare ()
@property (nonatomic,strong,readwrite) UIImage* posterImage;
@property (nonatomic,strong) ImageShare* posterImageShare;
@end

@implementation AlbumShare
@synthesize name = _name;
- (id) init {
    if (self = [super init]) {
        _assetShares = [NSMutableArray new];
    }
    return self;
}

- (id) initWithAssetsGroup:(ALAssetsGroup *)assetsGroup {
    if (self = [self init]) {
        _assetsGroup = assetsGroup;
        _name = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        _posterImage = [UIImage imageWithCGImage:[_assetsGroup posterImage]];
        _posterImageShare = [ImageShare new];
        _posterImageShare.image = _posterImage;
    }
    return self;
}

- (void) addAssetShare:(ALAssetShare*)assetShare {
    [_assetShares addObject:assetShare];
}

- (void) sortAssets {
    [PicturesShare sortAssetSharesArray:_assetShares];
}

- (NSInteger) numberOfPrivatePictures {
    return [PicturesShare numberOfPrivatePicturesInAssetSharesArray:_assetShares];
}

- (NSInteger) numberOfPictures {
    return [_assetShares count];
}

- (NSInteger) numberOfPicturesForWeb {
    return [self numberOfPictures] - [self numberOfPrivatePictures];
}

- (NSDictionary*) specificMacrosDict {
    return
    @{
      @"pictures_is_shared":@(self.isShared),
      @"show_link_pasteboard":@(YES),
      @"show_link_text":@(YES),
      @"show_link_pictures":@(YES),
      @"pictures_html_block":self.isShared ? [self htmlBlock] : @"",
      @"warning":@"",
      @"is_warning_shown":@(NO),
      //this is needed for template check:
      NSStringFromClass([PicturesShare class]):@(YES)
      };
}

- (NSDictionary*) macrosDictForList {
    CGSize posterImageSize = self.posterImage.size;
    return
    @{
             @"album_share_href":self.path,
             @"poster_image_src":[self posterImagePath],
             @"img_width_t":@(posterImageSize.width),
             @"img_height_t":@(posterImageSize.height),
             @"album_share_name":self.name,
             @"number_of_pictures":@([self numberOfPicturesForWeb]),
    };
}

- (NSString*) htmlBlock {
    NSMutableString* html = [NSMutableString stringWithFormat:@"<h2>Album: %@</h2> <p>(Pics: %d)</p>",self.name,[self numberOfPicturesForWeb]];
    for (ALAssetShare* assetShare in _assetShares) {
        if ([assetShare isShared]) {
            [html appendString:[assetShare htmlBlock]];
        }
    }
    return html;
}

- (NSString*) htmlBlockForList {
    self.macroPreprocessorForList.macroDict = [self macrosDictForList];
    return [self.macroPreprocessorForList process];
}

- (NSString*) posterImagePath {
    return [self.path stringByAppendingString:PATH_SUFFIX_POSTER];
}

@end