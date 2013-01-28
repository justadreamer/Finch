//
//  TableModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>
#import "TableModelConstants.h"

@class CellModel;
@class SectionModel;
@interface TableModel : NSObject
@property (nonatomic,strong) NSMutableArray* sections;

- (CellModel*) cellModelForIndexPath:(NSIndexPath*)indexPath;
- (SectionModel*) sectionModelForSection:(NSInteger)section;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfRowsInSection:(NSInteger)section;

- (void)setSectionsFromArray:(NSArray*)sections;
- (void)addSections:(NSArray*)sections;
- (void)addSection:(id)section;

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section;

@end