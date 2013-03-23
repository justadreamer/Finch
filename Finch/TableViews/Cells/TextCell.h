//
//  TextCell.h
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "BaseCell.h"
extern NSString* const kTextCellBeginEditingNotification;
extern NSString* const kTextCellDidEndEditingNotification;
extern NSString* const kTextCellResignFirstResponderNotification;

@interface TextCell : BaseCell
- (void) updateTextView;
@end
