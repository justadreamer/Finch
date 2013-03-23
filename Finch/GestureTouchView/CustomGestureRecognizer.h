//
//  CustomeGestureRecognizer.h
//  Finch
//
//  Created by Eugene Dorfman on 2/9/13.
//
//

#import <UIKit/UIKit.h>
@class TransparentTouchView;

@interface CustomGestureRecognizer : UIGestureRecognizer
@property (nonatomic,weak) TransparentTouchView* touchView;
@end
