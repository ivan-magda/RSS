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

@implementation RSSDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebViewDelegate -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self.activityIndicator startAnimating];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
}

@end
