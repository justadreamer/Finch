//
//  PictureViewCell.h
//  Finch
//
//  Created by Eugene Dorfman on 1/31/13.
//
//

#import <UIKit/UIKit.h>
@class ALAssetShare;

@interface PictureViewCell : UICollectionViewCell
@property (nonatomic,weak) ALAssetShare* assetShare;
- (void) refresh;
@end
