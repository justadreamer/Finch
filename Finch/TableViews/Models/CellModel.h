//
//  CellModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>
#import "KVCBaseObject.h"
#import "BaseCellAdapter.h"

@class BaseCell;

@interface CellModel : KVCBaseObject
@property (nonatomic,strong) NSString* className;
@property (nonatomic,strong) NSObject* model;

//should be set from the outside
@property (nonatomic,strong) NSString* identifier;

//the cell style if we are not loading cell from nib
@property (nonatomic,assign) UITableViewCellStyle style;

//if empty - no nib will be loaded (we'll assume the class is just alloc init)
@property (nonatomic,strong) NSString* nibName;

@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,strong) NSObject* adapter;

@property (nonatomic,strong) UIColor* detailTextColor;

@property (nonatomic,assign) UITableViewCellAccessoryType accessoryType;

- (BaseCellAdapter*)cellAdapter;

- (BaseCell*) createCell;

@end