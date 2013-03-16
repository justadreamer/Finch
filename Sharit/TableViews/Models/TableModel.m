//
//  TableModel.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import "TableModel.h"
#import "SectionModel.h"
#import "CellModel.h"
#import "BaseCell.h"
#import "TextCell.h"

@implementation TableModel

- (id) init {
    self = [super init];
    _sections = [[NSMutableArray alloc] init];
    return self;
}

- (CellModel*) cellModelForIndexPath:(NSIndexPath*)indexPath {
    SectionModel* sectionModel = [self.sections objectAtIndex:indexPath.section];
    CellModel* cellModel = [sectionModel.cellModels objectAtIndex:indexPath.row];
    return cellModel;
}

- (SectionModel*) sectionModelForSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

- (NSInteger) numberOfSections {
    return [self.sections count];
}

- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    SectionModel* sectionModel = [self sectionModelForSection:section];
    return [sectionModel.cellModels count];
}

- (void)setSectionsFromArray:(NSArray*)sections {
    [self.sections removeAllObjects];
    [self addSections:sections];
}

- (void)addSections:(NSArray*)sections {
    for (id section in sections) {
        [self addSection:section];
    }
}

- (void)addSection:(id)section {
    if ([section isKindOfClass:[SectionModel class]]) {
        [self.sections addObject:section];
    } else if ([section isKindOfClass:[NSDictionary class]]) {
        SectionModel* sectionModel = (SectionModel*)[SectionModel objectForDictionary:section];
        [self.sections addObject:sectionModel];
    }
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel* cellModel = [self cellModelForIndexPath:indexPath];

    BaseCell* cell = (BaseCell*) [tableView dequeueReusableCellWithIdentifier:[cellModel identifier]];
    if (nil==cell) {
        cell = [cellModel createCell];
    }
    cell.tableView = tableView;
    [cell updateWithAdapter:[cellModel cellAdapter]];
    [cell updateWithModel:[cellModel model]];
    cell.accessoryType = [cellModel accessoryType];
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel* sectionModel = [self sectionModelForSection:section];
    return sectionModel.titleForHeader;
}

- (NSString*)tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section {
    SectionModel* sectionModel = [self sectionModelForSection:section];
    return sectionModel.titleForFooter;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell* cell = (BaseCell*) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = [cell cellHeight];
    if (cellHeight>tableView.rowHeight)
        return cellHeight;
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TextCell class]]) {
        [self performSelector:@selector(updateTextView:) withObject:cell afterDelay:0.1];
    }
}

- (void) updateTextView:(TextCell*)cell {
    [(TextCell*)cell updateTextView];
}

@end