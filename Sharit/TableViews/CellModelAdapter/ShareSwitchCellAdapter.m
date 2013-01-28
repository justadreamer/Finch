//
//  SwitchCellModelAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/27/13.
//
//

#import "ShareSwitchCellAdapter.h"
#import "Share.h"

@implementation ShareSwitchCellAdapter
- (NSString*) mainText {
    return @"Is shared?";
}

- (BOOL) isOn {
    return [self share].isShared;
}

- (void) setIsOn:(BOOL)isOn {
    [self share].isShared = isOn;
}

- (Share*)share {
    return (Share*) self.model;
}
@end
