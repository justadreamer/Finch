//
//  AlbumShareCell.h
//  Finch
//
//  Created by Eugene Dorfman on 3/16/13.
//
//

#import "BaseCell.h"

@interface AlbumShareCell : BaseCell
@property (nonatomic,strong) IBOutlet UIImageView* thumbnail;
@property (nonatomic,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic,strong) IBOutlet UILabel* detailLabel;
@end
