//
//  ClipboardShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PasteboardShareController.h"
#import "PasteboardShare.h"
#import "ImageShare.h"
#import "PasteboardShareTextCellAdapter.h"
#import "PasteboardShareImageCellAdapter.h"

@interface PasteboardShareController ()
@property (nonatomic,strong) UITextView* textView;
@property (nonatomic,strong) UIImageView* imageView;
@end

@implementation PasteboardShareController
@synthesize textView;
@synthesize imageView;

- (void) viewDidLoad {
    [super viewDidLoad];
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PasteboardShare*) clipboardShare {
    return (PasteboardShare*) self.share;
}

- (void) refresh {
    PasteboardShare* share = [self clipboardShare];
    self.textView.text = [share string];
    ImageShare* imageShare = [share imageShare]; 
    self.imageView.image = [imageShare imageForSizeType:ImageSize_Medium];
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (void) initTableModel {
    [super initTableModel];
    if ([[self pasteboardShare].string length]) {
        NSDictionary* textCell = @{kCellClassName : @"TextCell",
                                   kCellNibName : @"TextCell",
                                   kCellAdapter: [PasteboardShareTextCellAdapter new],
                                   kCellModel: self.share
                                   };
        
        [self.tableModel addSection:@{
                             kSectionTitleForHeader: @"Pasteboard text:",
             kSectionTitleForFooter: @"Notice: You do NOT need to copy the text. The text IS already in the pasteboard",
                             kSectionCellModels: @[textCell]
         }];
    }
    
    if ([self pasteboardShare].image) {
        NSDictionary* imageCell = @{kCellClassName: @"ImageCell",
                                    kCellNibName: @"ImageCell",
                                    kCellAdapter: [PasteboardShareImageCellAdapter new],
                                    kCellModel: self.share};
        
        [self.tableModel addSection:@{
                             kSectionTitleForHeader:@"Pasteboard image:",
                             kSectionCellModels:@[imageCell]
         }];
    }
}

- (PasteboardShare*)pasteboardShare {
    return (PasteboardShare*)self.share;
}
@end