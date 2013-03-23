//  TransparentTouchView.h
//
//  Created by Eugene Dorfman on 4/15/11.
//  Copyright 2011 Postindustria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentTouchViewDelegate.h"

@interface TransparentTouchView : UIView {
    
}

@property (nonatomic,strong) NSMutableArray* points;
@property (nonatomic,strong) UIColor* strokeColor;
@property (nonatomic,weak) UIScrollView* scrollViewToPreventScrolling;
@property (nonatomic,weak) NSObject<TransparentTouchViewDelegate>* delegate;
//add this to your view:
@property (nonatomic,strong) UIGestureRecognizer* recognizer;

- (void) resetPoints;
- (void) addPoint:(CGPoint)point;
- (void) addPointsFromTouches:(NSSet*)touches;
- (void) touchesEnded;
- (NSSet*) view:(UIView*)view subviewsOfClass:(Class)subviewClass underPoints:(NSArray*)points;

@end
