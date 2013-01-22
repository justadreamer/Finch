//
//  CellModel.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import "CellModel.h"
#import "TableModelConstants.h"
#import "BaseCellModelAdapter.h"
#import "BaseCell.h"

@implementation CellModel

- (id) initWithCellClassName:(NSString*)cellClass model:(NSObject*)model adapter:(BaseCellModelAdapter*)adapter identifier:(NSString *)cellIdentifier {
    self = [self init];
    self.cellClassName = cellClass;
    self.model = model;
//    self.cellModelAdapter = adapter;
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

- (void) setCellModelAdapter:(BaseCellModelAdapter *)cellModelAdapter {
    _cellModelAdapter = cellModelAdapter;
}

- (BaseCellModelAdapter*)adapter {
    BaseCellModelAdapter* adapter = (BaseCellModelAdapter*) _cellModelAdapter;
    adapter.model = _model;
    return adapter;
}

@end