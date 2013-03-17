//
//  TextShare.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextShare.h"
#import "Helper.h"

@implementation TextShare
@synthesize text=_text;

- (id) init {
    if ((self = [super init])) {
        self.name = @"Text";
    }
    return self;
}

NSString* const textFilePath = @"TextShare.txt";
- (NSString*)path {
    return [[[Helper instance] documentsFolder] stringByAppendingPathComponent:textFilePath];
}

- (void) loadText {
    NSError* error = nil;
    NSString* path = [self path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        _text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            VLog(error);
        }
    }
}

- (void) saveText {
    NSError* error = nil;
    [self.text writeToFile:[self path] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        VLog(error);
    }
}

- (NSString*) text {
    if (!_text) {
        [self loadText];
    }
    return _text;
}

- (void) setText:(NSString *)text {
    _text = text;
    [self saveText];
}

- (NSString*) detailsDescription {
    NSString* desc = @"No text";
    NSInteger length = [self.text length];
    if (length) {
        desc = [NSString stringWithFormat:@"Text length: %d",length];
    }
    return desc;
}

- (NSDictionary*)specificMacrosDict {
    return @{
             kText: self.isShared ? SAFE_STRING([self text]) : @"",
             @"show_link_pasteboard":@(YES),
             @"show_link_pictures":@(YES)
                        };
}

- (void) processRequestData:(NSDictionary *)dict {
    NSString* newText = [dict objectForKey:kText];
    if (newText) {
        [self setText:newText];
    }
}
@end
