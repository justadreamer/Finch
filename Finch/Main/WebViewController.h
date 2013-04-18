//
//  HelpViewController.h
//  Finch
//
//  Created by Eugene Dorfman on 4/18/13.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
- (instancetype) initWithTitle:(NSString*)title URL:(NSURL*)url;
- (instancetype) initWithTitle:(NSString *)title request:(NSURLRequest *)request;
@end
