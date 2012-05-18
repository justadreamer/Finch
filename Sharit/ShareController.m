//
//  ShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareController.h"
#import "Share.h"
#import "ClipboardShare.h"
#import "TextShare.h"
#import "PicturesShare.h"
#import "ClipboardShareController.h"

@interface ShareController ()

@end

@implementation ShareController
@synthesize share;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (ShareController*) controllerWithShare:(Share*)share {
    ShareController* shareController = nil;
    if ([share isKindOfClass:[ClipboardShare class]]) {
        shareController = [[ClipboardShareController alloc] init];
    }
    shareController.share = share;
    return shareController;
}

@end