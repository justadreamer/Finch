//
//  CellModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>
#import "KVCBaseObject.h"

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

- (id) initWithCellClassName:(NSString*)cellClass model:(NSObject*)model identifier:(NSString *)cellIdentifier;

- (UITableViewCell*) createCell;
@end
