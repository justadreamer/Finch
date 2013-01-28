//
//  ShareCellModelAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import "ShareCellAdapter.h"
#import "Share.h"

@implementation ShareCellAdapter

- (Share*) shareModel {
    return (Share*)self.model;
}

- (NSString*) mainText {
    return [self shareModel].name;
}

- (NSString*) detailText {
    return [self shareModel].detailsDescription;
}

- (UITableViewCellAccessoryType) accessoryType {
    return  UITableViewCellAccessoryNone;
}

- (BOOL) showCheckMark {
    return [self shareModel].isShared;
}

- (UIColor*) detailTextColor {
    return [[self shareModel] isDetailsDescriptionAWarning] ? [UIColor redColor] : [UIColor blueColor];
}

@end
