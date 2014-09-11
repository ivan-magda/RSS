//
//  RSSDetailViewController.h
//  RSS
//
//  Created by Ivan Magda on 05.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSDetailViewController;

@protocol RSSDetailViewControllerProtocol <NSObject>

- (void)rssDetailViewController:(RSSDetailViewController *)controller showPreviousNewsBeforeCurrent:(NSString *)link;

- (void)rssDetailViewController:(RSSDetailViewController *)controller showNextNewsAfterCurrent:(NSString *)link;

@end

@interface RSSDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)showPreviousPressed:(UIBarButtonItem *)sender;
- (IBAction)showNextPressed:(UIBarButtonItem *)sender;

@property (copy, nonatomic) NSString *link;
@property (strong, nonatomic) id<RSSDetailViewControllerProtocol> delegate;

@end
