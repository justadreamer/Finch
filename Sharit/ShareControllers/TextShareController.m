//
//  TextShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/14/12.
//
//

#import "TextShareController.h"
#import "TextShare.h"
#import "TextShareTextCellAdapter.h"

@interface TextShareController ()
@end

@implementation TextShareController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (TextShare*) textShare {
    return (TextShare*) self.share;
}


#pragma mark -

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
