//
//  BaseCell.h
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import <Foundation/Foundation.h>
@class BaseCellAdapter;

@interface BaseCell : UITableViewCell
@property (nonatomic,weak) UITableView* tableView;

- (void) updateWithAdapter:(BaseCellAdapter*)adapter;
- (CGFloat) cellHeight;
@end
