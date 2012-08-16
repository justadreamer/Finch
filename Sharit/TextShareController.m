//
//  TextShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 8/14/12.
//
//

#import "TextShareController.h"
#import "TextShare.h"

@interface TextShareController ()<UITextViewDelegate>
@property (nonatomic,strong) IBOutlet UITextView* textView;
@property (nonatomic,strong) UIBarButtonItem* doneButton;
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
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
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

- (void) showDoneButton:(BOOL)show {
    self.navigationItem.rightBarButtonItem = show ? self.doneButton : nil;
}

- (void) doneButtonTapped:(id)sender {
    [self.textView resignFirstResponder];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView {
    [self showDoneButton:YES];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    [self textShare].text = textView.text;
    [self showDoneButton:NO];
}

#pragma mark -

@end
