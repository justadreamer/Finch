//
//  SectionModel.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import "SectionModel.h"

@implementation SectionModel
@synthesize titleForHeader;
@synthesize titleForFooter;
@synthesize cellModels;
@synthesize tag;

- (id) init {
    self = [super init];
    self.cellModels = [[NSMutableArray alloc] init];
    return self;
}

- (void) addCellModel:(id)cellModel {
    [self.cellModels addObject:cellModel];
}
@end
