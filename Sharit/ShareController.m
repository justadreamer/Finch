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
#import "TextShareController.h"

@interface ShareController ()

@end

@implementation ShareController
@synthesize share;
@synthesize isSharedSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.share.name;
    [self.isSharedSwitch setOn:self.share.isShared];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (ShareController*) controllerWithShare:(Share*)share {
    ShareController* shareController = nil;
    if ([share isKindOfClass:[ClipboardShare class]]) {
        shareController = [[ClipboardShareController alloc] init];
    } else if ([share isKindOfClass:[TextShare class]]) {
        shareController = [[TextShareController alloc] init];
    }
    shareController.share = share;
    return shareController;
}

- (void) sharesRefreshed {
    
}

- (IBAction)switchValueChanged:(UISwitch*)sender {
    self.share.isShared = sender.isOn;
}

@end