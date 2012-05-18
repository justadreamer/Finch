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
#import "Share.h"

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

    Share* clipboard = [[ClipboardShare alloc] init];
    [_shares addObject:clipboard];

    Share* text = [[TextShare alloc] init];
    [_shares addObject:text];

    Share* picture = [[PicturesShare alloc] init];
    [_shares addObject:picture];

    return _shares;
}

- (ClipboardShare*) clipboardShare {
    ClipboardShare* clipboardShare = nil;
    for (Share* share in self.shares) {
        if ([share isKindOfClass:[ClipboardShare class]]) {
            clipboardShare = (ClipboardShare*) share;
        }
    }
    return clipboardShare;
}
@end