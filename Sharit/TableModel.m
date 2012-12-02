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
    for (id section in sections) {
        if ([section isKindOfClass:[SectionModel class]]) {
            [self.sections addObject:section];
        } else if ([section isKindOfClass:[NSDictionary class]]) {
            SectionModel* sectionModel = (SectionModel*)[SectionModel objectForDictionary:section];
            [self.sections addObject:sectionModel];
        }
    }
}
@end