//
//  CellModel.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import "CellModel.h"

@implementation CellModel
@synthesize cellClass;
@synthesize model;
@synthesize nibNameToLoad;
@synthesize cellStyle;
@synthesize cellIdentifier;
@synthesize tag;

- (id) initWithCellClass:(Class)_cellClass model:(NSObject*)_model identifier:(NSString *)_cellIdentifier{
    self = [self init];
    self.cellClass = _cellClass;
    self.model = _model;
    self.cellIdentifier = _cellIdentifier;
    return self;
}

- (UITableViewCell*) createCell {
    UITableViewCell* cell = nil;
    if ([self.nibNameToLoad length]) {
        NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:self.nibNameToLoad owner:nil options:nil];
        if ([nibArray count]>0) {
            cell = [nibArray objectAtIndex:0];
        }
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:[self cellIdentifier]];
    }

    return cell;
}

@end