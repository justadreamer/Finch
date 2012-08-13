//
//  Iface.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Iface.h"
#import "GlobalDefaults.h"

@implementation Iface
@synthesize name;
@synthesize ipAddress;

- (NSString*) url {
    UInt16 port = [GlobalDefaults port];
    NSString* portString = 80 == port ? @"" : [NSString stringWithFormat:@":%d",port];
    return [NSString stringWithFormat:@"http://%@%@",ipAddress,portString];
}
@end
