//
//  PicturesPrivateViewController.h
//  Finch
//
//  Created by Eugene Dorfman on 1/31/13.
//
//

#import <UIKit/UIKit.h>
@class PicturesShare, AlbumShare;
@interface PicturesPrivateViewController : UICollectionViewController
@property (nonatomic,strong) AlbumShare* albumShare;
@end
