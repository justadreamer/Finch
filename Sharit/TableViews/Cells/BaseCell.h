//
//  BaseCell.h
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import <Foundation/Foundation.h>
@class BaseCellModelAdapter;

@interface BaseCell : UITableViewCell
- (void) updateWithAdapter:(BaseCellModelAdapter*)adapter;
@end
