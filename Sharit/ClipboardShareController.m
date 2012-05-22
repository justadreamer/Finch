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

- (void) viewDidLoad {
    [super viewDidLoad];
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (ClipboardShare*) clipboardShare {
    return (ClipboardShare*) self.share;
}

- (void) refresh {
    self.textView.text = [[self clipboardShare] string];
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (void) sharesRefreshed {
    [self refresh];
}

@end