//
//  SharesProvider.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharesProvider.h"
#import "Share.h"
#import "ClipboardShare.h"
#import "TextShare.h"
#import "PicturesShare.h"
#import "GlobalDefaults.h"
#import "ImageShare.h"
#import "BasicTemplateLoader.h"
#import "Helper.h"

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
    Share* clipboard = [[ClipboardShare alloc] initWithTemplateLoader:basicLoader];

    clipboard.templateLoader = basicLoader;
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

- (ClipboardShare*) clipboardShare {
    return (ClipboardShare*)[self shareForClass:[ClipboardShare class]];
}

- (TextShare*) textShare {
    return (TextShare*)[self shareForClass:[TextShare class]];
}

- (PicturesShare*) picturesShare {
    return (PicturesShare*)[self shareForClass:[PicturesShare class]];
}

- (Share*) shareForPath:(NSString*)path {
    Share* share = nil;
    if ([path isEqualToString:URLClipboardImage]) {
        share = [[self clipboardShare] imageShare];
    } else if ([path contains:@"text"]) {
        share = [self textShare];
    } else if ([path contains:@"pictures"]) {
        share = [self picturesShare];
    } else {
        share = [self clipboardShare];
    }
    return share;
}


@end