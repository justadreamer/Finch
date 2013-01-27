//
//  SectionModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>
#import "KVCBaseObject.h"
@class CellModel;
@interface SectionModel : KVCBaseObject
@property (nonatomic,strong) NSString* titleForHeader;
@property (nonatomic,strong) NSString* titleForFooter;
@property (nonatomic,strong) NSMutableArray* cellModels;
@property (nonatomic,assign) NSInteger tag;

- (void) addCellModel:(CellModel*)cellModel;

@end
