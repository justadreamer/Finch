//
//  CellModel.h
//  Sharit
//
//  Created by Eugene Dorfman on 8/12/12.
//
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject
@property (nonatomic,strong) Class cellClass;
@property (nonatomic,strong) NSObject* model;

//should be set from the outside
@property (nonatomic,strong) NSString* cellIdentifier;

//the cell style if we are not loading cell from nib
@property (nonatomic,assign) UITableViewCellStyle cellStyle;

//if empty - no nib will be loaded (we'll assume the class is just alloc init)
@property (nonatomic,strong) NSString* nibNameToLoad;

@property (nonatomic,assign) NSInteger tag;

- (id) initWithCellClass:(Class)_cellClass model:(NSObject*)_model identifier:(NSString*)_cellIdentifier;

- (UITableViewCell*) createCell;
@end
