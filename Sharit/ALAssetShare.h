//
//  ALAssetShare.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/23/12.
//
//

#import "Share.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetShare : Share
@property (nonatomic,strong) ALAsset* asset;
@property (nonatomic,strong) NSString* thumbPath;

- (NSString*) htmlBlock;
- (NSData*) dataForPath:(NSString*)path;
@end
