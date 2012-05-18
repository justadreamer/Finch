//
//  SharesResponseFormatter.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharesResponseFormatter.h"
#import "SharesProvider.h"
#import "ClipboardShare.h"

@implementation SharesResponseFormatter

- (NSString*) connection:(HTTPConnection*)connection responseForPath:(NSString*)path {
    return [self processMacrosInTemplate:@"index"];
}

- (NSString*) replaceMacro:(NSString *)macro {
    NSString* replacement = @"";
    if ([macro isEqualToString:@"%clipboard%"]) {
        ClipboardShare* clipboardShare = [[SharesProvider instance] clipboardShare];
        replacement = [clipboardShare string];
    }
    return replacement;
}
@end
