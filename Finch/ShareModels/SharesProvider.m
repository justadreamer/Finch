//
//  SharesProvider.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharesProvider.h"
#import "Share.h"
#import "PasteboardShare.h"
#import "TextShare.h"
#import "PicturesShare.h"
#import "GlobalDefaults.h"
#import "ImageShare.h"


#import "ALAssetShare.h"

#import "RootShare.h"

@interface SharesProvider() {
    
}
@property (nonatomic,strong) RootShare* rootShare;
@end

@implementation SharesProvider

SharesProvider* globalSharesProvider;
+ (SharesProvider*) instance {
    if (nil==globalSharesProvider) {
        globalSharesProvider = [[SharesProvider alloc] init];
    }
    return globalSharesProvider;
}

- (id) init {
    if ((self = [super init])) {
        _rootShare = [RootShare new];
    }
    return self;
}

- (NSArray*)shares {
    return _rootShare.children;
}

- (Share*) shareForClass:(Class)shareClass {
    for (Share* share in self.shares) {
        if ([share isKindOfClass:shareClass]) {
            return share;
        }
    }
    return nil;
}

- (PasteboardShare*) clipboardShare {
    return (PasteboardShare*)[self shareForClass:[PasteboardShare class]];
}

- (TextShare*) textShare {
    return (TextShare*)[self shareForClass:[TextShare class]];
}

- (PicturesShare*) picturesShare {
    return (PicturesShare*)[self shareForClass:[PicturesShare class]];
}

- (Share*) shareForPath:(NSString*)path andParams:(NSDictionary*)params {
    Share* share = nil;
    if ([path isEqualToString:URLClipboardImage]) {
        share = [[self clipboardShare] imageShare];
    } else if ([path contains:PATH_TEXT]) {
        share = [self textShare];
    } else if ([path contains:PATH_PICTURES]) {
        share = [self picturesShare];
    } else if ([path contains:PATH_PREFIX_ASSET]){
        share = [[self picturesShare] shareForPath:path];
    } else if ([path contains:PATH_PREFIX_ALBUM]) {
        share = [[self picturesShare] shareForPath:path];
    } else if ([path contains:PATH_INDEX]){
        share = [self clipboardShare];
    }
    return share;
}

- (void) refreshShares {
    __weak SharesProvider* safeSelf = (SharesProvider*) self;
    [self picturesShare].onRefreshFinished = ^(NSError* error) {
        if (safeSelf.onRefreshFinished) {
            safeSelf.onRefreshFinished(error);
        }
    };
    [[self picturesShare] refresh];
}

@end