//
//  PictureViewCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/31/13.
//
//

#import "PictureViewCell.h"
@interface PictureViewCell()
@property (nonatomic,strong) IBOutlet UIImageView* imageView;
@end

@implementation PictureViewCell

- (void)setImage:(UIImage*) image {
    self.imageView.image = image;
}

@end
