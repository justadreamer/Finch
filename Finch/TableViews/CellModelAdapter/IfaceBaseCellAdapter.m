//
//  IfaceCellModelAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/11/13.
//
//

#import "IfaceBaseCellAdapter.h"
#import "Iface.h"

@implementation IfaceBaseCellAdapter

- (NSString*)mainText {
    return [self iface].url;
}

- (NSString*)detailText {
    return [self iface].name;
}

- (Iface*) iface {
    return (Iface*)self.model;
}

@end