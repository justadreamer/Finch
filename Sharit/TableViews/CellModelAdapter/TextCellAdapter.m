//
//  TextCellAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "TextCellAdapter.h"

@implementation TextCellAdapter

- (BOOL) isEditable {
    return NO;
}

- (NSString*)text {
    return @"";
}

- (void) setText:(NSString *)text {
    
}

@end