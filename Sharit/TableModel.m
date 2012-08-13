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

@implementation TableModel
@synthesize sections;

- (id) init {
    self = [super init];
    sections = [[NSMutableArray alloc] init];
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
@end
