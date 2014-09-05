//
//  RSSDetailViewController.m
//  RSS
//
//  Created by Ivan Magda on 05.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController ()

@end

@implementation RSSDetailViewController {
    BOOL _isShowAnimate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    _isShowAnimate = YES;
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebViewDelegate -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (_isShowAnimate) {
        _isShowAnimate = NO;
        [self.activityIndicator startAnimating];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _isShowAnimate = NO;
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
}

@end
