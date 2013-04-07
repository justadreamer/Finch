//
//  SiblingSharesProvider.h
//  Finch
//
//  Created by Eugene Dorfman on 4/6/13.
//
//

#import <Foundation/Foundation.h>
@class Share;
@protocol SiblingSharesProvider <NSObject>
- (NSArray*)siblingSharesForShare:(Share*)share excludeSelf:(BOOL)exclude;
@end
