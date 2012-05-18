//
//  ClipboardShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClipboardShareController.h"
#import "ClipboardShare.h"

@interface ClipboardShareController ()
@property (nonatomic,strong) IBOutlet UITextView* textView;
@end

@implementation ClipboardShareController
@synthesize textView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (ClipboardShare*) clipboardShare {
    return (ClipboardShare*) self.share;
}

- (void) viewWillAppear:(BOOL)animated {
    self.textView.text = [[self clipboardShare] string];
}

@end
