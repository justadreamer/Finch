//
//  HelpViewController.m
//  Finch
//
//  Created by Eugene Dorfman on 4/18/13.
//
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (nonatomic,strong) UIWebView* webView;
@end

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Help";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSURL* url = [[NSBundle mainBundle] resourceURL];
    url = [url URLByAppendingPathComponent:docrootFolderName];
    url = [url URLByAppendingPathComponent:HELP_FILE];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}

@end