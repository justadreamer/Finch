//
//  TableModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>
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
@end
