//
//  ALAssetShare.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/23/12.
//
//

#import "ImageShare.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetShare : ImageShare
@property (nonatomic,strong) ALAsset* asset;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,readonly) ALAssetRepresentation* defaultRepresentation;
@property (nonatomic,assign) BOOL isPrivate;
@property (nonatomic,strong) NSString* fileName;

+ (BOOL) isAssetVideo:(ALAsset*)asset;
#ifdef UNIT_TESTS
+ (NSString*) durationStringFromDouble:(double)d;
#endif
- (NSDate*) createdDate;

- (void) readPrivacyPreference;
@end
