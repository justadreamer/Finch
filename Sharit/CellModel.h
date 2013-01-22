//
//  CellModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>
#import "KVCBaseObject.h"
#import "BaseCellModelAdapter.h"
#import "CellModelAdapter.h"

@class BaseCell;

@interface CellModel : KVCBaseObject
@property (nonatomic,strong) NSString* cellClassName;
@property (nonatomic,strong) NSObject* model;

//should be set from the outside
@property (nonatomic,strong) NSString* cellIdentifier;

//the cell style if we are not loading cell from nib
@property (nonatomic,assign) UITableViewCellStyle cellStyle;

//if empty - no nib will be loaded (we'll assume the class is just alloc init)
@property (nonatomic,strong) NSString* nibNameToLoad;

@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,strong) NSObject* cellModelAdapter;

- (BaseCellModelAdapter*)adapter;

- (id) initWithCellClassName:(NSString*)cellClass model:(NSObject*)model adapter:(BaseCellModelAdapter*)adapter identifier:(NSString *)cellIdentifier;

- (BaseCell*) createCell;

@end
