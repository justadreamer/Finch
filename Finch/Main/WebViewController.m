//
//  HelpViewController.m
//  Finch
//
//  Created by Eugene Dorfman on 4/18/13.
//
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView* webView;
@end

@implementation WebViewController

- (instancetype) initWithTitle:(NSString*)title URL:(NSURL*)url {
    return [self initWithTitle:title request:[NSURLRequest requestWithURL:url]];
}

- (instancetype) initWithTitle:(NSString *)title request:(NSURLRequest *)request {
    if (self = [self init]) {
        self.title = title;
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.webView];
        self.webView.delegate = self;
        [self.webView loadRequest:request];
    }
    return self;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
        if ([request.URL isFileURL]) {
            WebViewController* webViewController = [[WebViewController alloc] initWithTitle:@"" request:request];
            [self.navigationController pushViewController:webViewController animated:YES];
        } else {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return NO;
    }
    return YES;
}

@end