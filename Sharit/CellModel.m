//
//  CellModel.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import "CellModel.h"
#import "TableModelConstants.h"

@implementation CellModel

- (id) initWithCellClassName:(NSString*)cellClass model:(NSObject*)model identifier:(NSString *)cellIdentifier{
    self = [self init];
    self.cellClassName = cellClass;
    self.model = model;
    self.cellIdentifier = cellIdentifier;
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

- (NSString *)
getPropertyNameForJsonKey:(NSString *)jsonKey
{
    static NSDictionary* vars;
	if (!vars) {
		vars = @{
        kModel: @"model",
        kTag: @"tag",
        kCellId: @"cellIdentifier",
        kCellStyle : @"cellStyle",
        kNibNameToLoad : @"nibNameToLoad",
        kCellClassName : @"cellClassName"
		};
	}
	NSString* key = [vars objectForKey:jsonKey];
	
	return key;
}
@end