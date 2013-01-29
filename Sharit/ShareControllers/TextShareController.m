//
//  TextShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/14/12.
//
//

#import "TextShareController.h"
#import "TextShare.h"
#import "TextCell.h"
#import "TextShareTextCellAdapter.h"

@interface TextShareController ()

@end

@implementation TextShareController

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBeginEditingNotification:) name:kTextCellBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidEndEditingNotification:) name:kTextCellDidEndEditingNotification object:nil];
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (TextShare*) textShare {
    return (TextShare*) self.share;
}

- (void) handleBeginEditingNotification:(NSNotification*)notification {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}

- (void) handleDidEndEditingNotification:(NSNotification*)notification {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) done:(id)barButtonItem {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextCellResignFirstResponderNotification object:nil];
}

- (void) initTableModel {
    [super initTableModel];
    NSDictionary* textCell = @{kCellClassName : @"TextCell",
                               kNibNameToLoad : @"TextCell",
                               kAdapter: [TextShareTextCellAdapter new],
                               kModel: self.share
                               };
    
    [self.tableModel addSection:@{
                         kTitle: @"Text:",
                         kCells: @[textCell]
     }];
}

@end
