//
//  GlobalDefaults.h
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const URLClipboardImage = @"/clipboard-img.png";
static NSString* const URLimageBase = @"img";
static NSString* const templateExt = @"tpl";
static NSString* const templatesFolderName = @"tpl";
static NSString* const docrootFolderName = @"docroot";
static NSString* const PATH_PREFIX_ASSET = @"asset";
static NSString* const PATH_PREFIX_ASSET_THUMB = @"assetThumb";
static NSString* const PARAM_ASSET_ID = @"assetId";
static NSString* const ASSET_EXT = @".png";

@interface GlobalDefaults : NSObject
+ (UInt16) port;
@end
