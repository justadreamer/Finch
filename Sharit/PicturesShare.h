//
//  PicturesShare.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Share.h"
@class ALAssetShare;

@interface PicturesShare : Share
- (ALAssetShare*) shareForIndex:(NSInteger)index;
- (void) refresh;
@end
