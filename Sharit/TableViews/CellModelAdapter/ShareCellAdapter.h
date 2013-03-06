//
//  ShareCellModelAdapter.h
//  Finch
//
//  Created by Eugene Dorfman on 1/22/13.
//
//

#import "BaseCellAdapter.h"

@interface ShareCellAdapter : BaseCellAdapter
- (UITableViewCellAccessoryType) accessoryType;
- (BOOL) showCheckMark;
@end
