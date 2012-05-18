//
//  SharesProvider.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClipboardShare;
@interface SharesProvider : NSObject
@property (nonatomic,strong) NSMutableArray* shares;
+ (SharesProvider*) instance;
- (ClipboardShare*) clipboardShare;
@end
