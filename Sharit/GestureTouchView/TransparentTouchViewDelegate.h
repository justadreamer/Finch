//
//  TransparentTouchViewDelegate.h
//  Finch
//
//  Created by Eugene Dorfman on 2/9/13.
//
//

#import <Foundation/Foundation.h>
@class TransparentTouchView;

@protocol TransparentTouchViewDelegate <NSObject>
- (void) transparentTouchView:(TransparentTouchView*)transparentTouchView didEndTouchesWithPoints:(NSArray*)points;
@end
