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
#import "PicturesShareController.h"

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
    NSDictionary* controllerToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [ClipboardShareController class], [ClipboardShare class],
                                       [TextShareController class],[TextShare class],
                                       [PicturesShareController class],[PicturesShare class],
                                       nil];

    ShareController* shareController = nil;
    Class controllerClass = [controllerToShare objectForKey:[share class]];
    if (Nil!=controllerClass) {
        shareController = [[controllerClass alloc] init];
        shareController.share = share;
    }

    return shareController;
}

- (void) sharesRefreshed {
    
}

- (IBAction)switchValueChanged:(UISwitch*)sender {
    self.share.isShared = sender.isOn;
}

@end