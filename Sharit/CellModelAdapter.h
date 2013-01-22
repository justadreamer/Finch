//
//  CellModelAdapter.h
//  Finch
//
//  Created by Eugene Dorfman on 1/11/13.
//
//

#import <Foundation/Foundation.h>

@protocol CellModelAdapter <NSObject>
@property (nonatomic,weak) NSObject* model;

- (NSString*) mainText;
- (NSString*) detailText;
- (UITableViewCellAccessoryType) accessoryType;
- (BOOL) showCheckMark;
- (UIColor*) detailTextColor;

@end
