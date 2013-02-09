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
#import "BasicTemplateLoader.h"
#import "Helper.h"
#import "ALAssetShare.h"
#import "MacroPreprocessor.h"

@interface SharesProvider() {
    
}
- (NSMutableArray*) setupShares;
@end

@implementation SharesProvider
@synthesize shares;

SharesProvider* globalSharesProvider;
+ (SharesProvider*) instance {
    if (nil==globalSharesProvider) {
        globalSharesProvider = [[SharesProvider alloc] init];
    }
    return globalSharesProvider;
}

- (id) init {
    if ((self = [super init])) {
        self.shares = [self setupShares];
    }
    return self;
}

- (NSMutableArray*) setupShares {
    NSMutableArray* _shares = [NSMutableArray array];
    BasicTemplateLoader* basicLoader = [[BasicTemplateLoader alloc] initWithFolder:[[Helper instance] templatesFolder] templateExt:templateExt];
    MacroPreprocessor* macroPreprocessor = [[MacroPreprocessor alloc] initWithLoader:basicLoader templateName:@"index"];

    Share* clipboard = [[PasteboardShare alloc] initWithMacroPreprocessor:macroPreprocessor];
    [_shares addObject:clipboard];

    Share* text = [[TextShare alloc] init];
    [_shares addObject:text];

    Share* picture = [[PicturesShare alloc] init];
    [_shares addObject:picture];

    return _shares;
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
    } else if ([path contains:@"text"]) {
        share = [self textShare];
    } else if ([path contains:@"pictures"]) {
        share = [self picturesShare];
    } else if ([path contains:PATH_PREFIX_ASSET]){
        share = [[self picturesShare] shareForPath:path];
    } else {
        share = [self clipboardShare];
    }
    return share;
}

- (void) refreshShares {
    __weak SharesProvider* safeSelf = (SharesProvider*) self;
    [self picturesShare].onRefreshFinished = ^ {
        if (safeSelf.onRefreshFinished) {
            safeSelf.onRefreshFinished();
        }
    };
    [[self picturesShare] refresh];
}
@end