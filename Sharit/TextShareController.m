//
//  TextShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/14/12.
//
//

#import "TextShareController.h"
#import "TextShare.h"

@interface TextShareController ()
@property (nonatomic,strong) IBOutlet UITextView* textView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (TextShare*) textShare {
    return (TextShare*) self.share;
}

- (void) refresh {
    TextShare* share = [self textShare];
    self.textView.text = [share text];
}

- (void) sharesRefreshed {
    [self refresh];
}
@end
