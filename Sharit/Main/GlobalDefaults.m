//
//  GlobalDefaults.m
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalDefaults.h"

@implementation GlobalDefaults

+ (UInt16) port {
#if TARGET_IPHONE_SIMULATOR
    return 5000;
#else
    return 80;
#endif
}

@end