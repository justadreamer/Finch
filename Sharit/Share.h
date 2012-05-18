//
//  Share.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Share : NSObject
@property (nonatomic,assign) BOOL isShared;
@property (nonatomic,strong) NSString* name;
- (NSString*) detailsDescription;
@end