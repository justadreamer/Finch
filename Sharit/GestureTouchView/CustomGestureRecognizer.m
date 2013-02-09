//
//  CustomeGestureRecognizer.m
//  Finch
//
//  Created by Eugene Dorfman on 2/9/13.
//
//

#import "CustomGestureRecognizer.h"
#import "TransparentTouchView.h"

@implementation CustomGestureRecognizer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.touchView resetPoints];
    [self.touchView addPointsFromTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.touchView touchesEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.touchView resetPoints];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.touchView addPointsFromTouches:touches];
}

@end
