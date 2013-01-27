//
//  PicturesShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 9/10/12.
//
//

#import "PicturesShareController.h"
#import "Share.h"
@interface PicturesShareController ()
@property (nonatomic,strong) IBOutlet UILabel* warningLabel;
@end

@implementation PicturesShareController

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
    self.warningLabel.text = @"Please enable Location Services in order to share pictures";
    self.warningLabel.hidden = ![self.share isDetailsDescriptionAWarning];
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

@end
