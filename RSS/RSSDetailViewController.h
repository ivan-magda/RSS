//
//  RSSDetailViewController.h
//  RSS
//
//  Created by Ivan Magda on 05.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (copy, nonatomic) NSString *link;

@end
