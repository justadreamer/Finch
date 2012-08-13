//
//  SharesProvider.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClipboardShare;
@class Share;
@class TextShare;
@class PicturesShare;

@interface SharesProvider : NSObject
@property (nonatomic,strong) NSMutableArray* shares;
+ (SharesProvider*) instance;
- (ClipboardShare*) clipboardShare;
- (TextShare*) textShare;
- (PicturesShare*) picturesShare;
- (Share*) shareForPath:(NSString*)path;
@end
