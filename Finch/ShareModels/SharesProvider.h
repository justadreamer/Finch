//
//  SharesProvider.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PasteboardShare;
@class Share;
@class TextShare;
@class PicturesShare;

@interface SharesProvider : NSObject
@property (nonatomic,strong) NSMutableArray* shares;
@property(nonatomic,copy) ErrorBlock onRefreshFinished;

+ (SharesProvider*) instance;
- (PasteboardShare*) clipboardShare;
- (TextShare*) textShare;
- (PicturesShare*) picturesShare;
- (Share*) shareForPath:(NSString*)path andParams:(NSDictionary*)params;
- (void) refreshShares;
@end
