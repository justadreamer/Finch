//
//  BaseCellModelAdapter.h
//  Finch
//
//  Created by Eugene Dorfman on 1/11/13.
//
//

#import <Foundation/Foundation.h>

@interface BaseCellAdapter : NSObject
@property (nonatomic,weak) NSObject* model;

- (NSString*) mainText;
- (NSString*) detailText;

@end
