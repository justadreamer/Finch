//
//  Helper.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"
#import <ifaddrs.h>
#import <arpa/inet.h>  
#import "Iface.h"
@interface Helper() {
    
}
@property (nonatomic,strong) NSString* documentsFolder;
@property (nonatomic,strong) NSString* templatesFolder;
@property (nonatomic,strong) NSString* documentsRoot;
@end

@implementation Helper
@synthesize documentsFolder;
@synthesize templatesFolder;
@synthesize documentsRoot;

NSString* addressFrom_ifa_addr(struct sockaddr* ifa_addr) {
    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)ifa_addr)->sin_addr)];
}

+ (NSArray*) interfaces {
    NSMutableArray* ifaces = [NSMutableArray array];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                NSString* name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString* address = addressFrom_ifa_addr(temp_addr->ifa_addr);
                if(![address isEqualToString:@"127.0.0.1"]) {
                    Iface* iface = [[Iface alloc] init];
                    iface.name = name;
                    iface.ipAddress = address;
                    [ifaces addObject:iface];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    NSSortDescriptor* desc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [NSArray arrayWithArray:[ifaces sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]]];
}

+ (UInt16) port {
#if TARGET_IPHONE_SIMULATOR
    return 5000;
#else
    return 88;
#endif
}

Helper* sharedHelper;

+ (Helper*) instance {
    if (sharedHelper == nil) {
        sharedHelper = [[self alloc] init];
    }
    return sharedHelper;
}

+ (NSString*) templatesFolderName {
    return @"tpl";
}

+ (NSString*) templateExt {
    return @"tpl";
}

- (NSString*) documentsFolder {
    if (nil==documentsFolder) {
        documentsFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    }
    return documentsFolder;
}

- (NSString*) templatesFolder {
    if (nil==templatesFolder) {
        templatesFolder = [[self documentsFolder] stringByAppendingPathComponent:[Helper templatesFolderName]];
    }
    return templatesFolder;
}

- (NSString*) documentsRoot {
    if (nil==documentsRoot) {
        documentsRoot = [[self documentsFolder] stringByAppendingPathComponent:@"docroot"];
    }
    return documentsRoot;
}
@end
