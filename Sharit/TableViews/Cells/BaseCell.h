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
- (void) updateWithAdapter:(BaseCellAdapter*)adapter;
@end
