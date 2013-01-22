//
//  BaseCellModelAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/11/13.
//
//

#import "BaseCellModelAdapter.h"

@implementation BaseCellModelAdapter
@synthesize model;

- (NSString*) mainText {
    return @"";
}

- (NSString*) detailText {
    return @"";
}

- (UITableViewCellAccessoryType) accessoryType {
    return  UITableViewCellAccessoryNone;
}

- (BOOL) showCheckMark {
    return NO;
}

- (UIColor*) detailTextColor {
    return [UIColor blackColor];
}

@end
