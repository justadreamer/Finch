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
@property(nonatomic,strong) NSMutableArray* assetShares;
@property(nonatomic,strong) NSMutableArray* albumShares;
@property(nonatomic,copy) ErrorBlock onRefreshFinished;

- (ALAssetShare*) shareForPath:(NSString*)path;
- (void) refresh;
- (NSInteger)numberOfPrivatePictures;
+ (void) sortAssetSharesArray:(NSMutableArray*)assetShares;
+ (NSInteger) numberOfPrivatePicturesInAssetSharesArray:(NSArray*)assetShares;
@end
