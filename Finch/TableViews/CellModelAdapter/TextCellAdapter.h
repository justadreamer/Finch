//
//  TextCellAdapter.h
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "BaseCellAdapter.h"

@interface TextCellAdapter : BaseCellAdapter
@property (nonatomic,strong) NSString* text;
@property (nonatomic,assign,readonly) BOOL isEditable;
@end
