//
//  CellModel.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import "CellModel.h"
#import "TableModelConstants.h"
#import "BaseCellAdapter.h"
#import "BaseCell.h"

@implementation CellModel

- (id) initWithCellClassName:(NSString*)cellClass model:(NSObject*)model adapter:(BaseCellAdapter*)adapter identifier:(NSString *)cellIdentifier {
    self = [self init];
    self.cellClassName = cellClass;
    self.model = model;
    self.cellIdentifier = cellIdentifier;
    return self;
}

- (BaseCell*) createCell {
    BaseCell* cell = nil;
    if ([self.nibNameToLoad length]) {
        NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:self.nibNameToLoad owner:nil options:nil];
        if ([nibArray count]>0) {
            cell = [nibArray objectAtIndex:0];
        }
    } else {
        cell = [[BaseCell alloc] initWithStyle:self.cellStyle reuseIdentifier:[self cellIdentifier]];
    }

    return cell;
}

- (NSString *)
getPropertyNameForJsonKey:(NSString *)jsonKey
{
    static NSDictionary* vars = nil;
	if (!vars) {
		vars = @{
            kModel: @"model",
            kTag: @"tag",
            kCellId: @"cellIdentifier",
            kCellStyle : @"cellStyle",
            kNibNameToLoad : @"nibNameToLoad",
            kCellClassName : @"cellClassName",
            kAdapter : @"cellModelAdapter"
		};
	}
	NSString* key = [vars objectForKey:jsonKey];

	return key;
}

- (void) setModel:(NSObject *)model {
    _model = model;
}

- (void) setCellModelAdapter:(BaseCellAdapter *)cellModelAdapter {
    _cellModelAdapter = cellModelAdapter;
}

- (BaseCellAdapter*)adapter {
    BaseCellAdapter* adapter = (BaseCellAdapter*) _cellModelAdapter;
    adapter.model = _model;
    return adapter;
}

@end