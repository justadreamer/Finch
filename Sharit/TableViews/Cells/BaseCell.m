//
//  BaseCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import "BaseCell.h"
#import "BaseCellAdapter.h"

@implementation BaseCell
@synthesize tableView;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}

- (void) updateWithAdapter:(BaseCellAdapter*)adapter {
    self.textLabel.text = [(BaseCellAdapter*)adapter mainText];
    self.detailTextLabel.text = [(BaseCellAdapter*)adapter detailText];
    self.detailTextLabel.font = [UIFont systemFontOfSize:17];
    UIColor* detailTextColor = [adapter detailTextColor];
    if (nil!=detailTextColor) {
        self.detailTextLabel.textColor = detailTextColor;
    }
}

- (CGFloat) cellHeight {
    CGSize frameSize = self.contentView.frame.size;
    frameSize.height = INFINITY;
    UIFont* font = self.detailTextLabel.font;
    NSString* text = self.detailTextLabel.text;
    CGSize size = [text sizeWithFont:font constrainedToSize:frameSize lineBreakMode:UILineBreakModeWordWrap];
    
    static const CGFloat margins = 15;
    CGFloat height = size.height+2*margins;
    return height;
}

- (void) updateWithModel:(id)model {
    
}
@end