//
//  ImageCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "ImageCell.h"
#import "ImageCellAdapter.h"

@interface ImageCell()
@property (nonatomic,strong) IBOutlet UIImageView* imageView;

@end

@implementation ImageCell

- (void) updateWithAdapter:(ImageCellAdapter *)adapter {
    self.imageView.image = [adapter image];
}

- (CGFloat) cellHeight {
    static const CGFloat margins = 15;
    return self.imageView.frame.size.height + margins;
}

@end
