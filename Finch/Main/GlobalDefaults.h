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
static NSString* const templateExt = @"html";
static NSString* const templatesFolderName = @"tpl";
static NSString* const docrootFolderName = @"docroot";
static NSString* const PATH_INDEX = @"/index.html";
static NSString* const PATH_TEXT = @"/text.html";
static NSString* const PATH_PICTURES = @"/pictures.html";
static NSString* const PATH_PREFIX_ASSET = @"/asset/";
static NSString* const PATH_PREFIX_ALBUM = @"/album/";
static NSString* const PATH_SUFFIX_POSTER = @"/poster.jpeg";

static NSString* const TEMPLATE_INDEX = @"index";
static NSString* const TEMPLATE_VIDEO = @"video";
static NSString* const TEMPLATE_IMAGE = @"image";
static NSString* const TEMPLATE_ASSET = @"asset";
static NSString* const TEMPLATE_ALBUM_LIST_ITEM = @"album_list_item";

static NSString* const SUPPORT_EMAIL = @"eugene.dorfman@gmail.com";

@interface GlobalDefaults : NSObject
+ (UInt16) port;
@end
