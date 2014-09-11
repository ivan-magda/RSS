//
//  ViewController.m
//  RSS
//
//  Created by Ivan Magda on 05.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "RSStableViewController.h"

#import <TBXML/TBXML.h>


static const int kTextlabelTag = 100;
static const int kActivityIndicatorTag = 101;

@interface RSStableViewController ()

@end

@implementation RSStableViewController {
    NSMutableArray *_titles;
    NSMutableArray *_links;
    BOOL _animateIndicator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titles = [[NSMutableArray alloc]initWithCapacity:30];
    _links = [[NSMutableArray alloc]initWithCapacity:30];
    
    _animateIndicator = YES;
    
    [self parseXML];
}

- (void)parseXML {
    dispatch_queue_t parseQueue = dispatch_queue_create("parse queue", 0);
    dispatch_async(parseQueue, ^{
        NSURL *URL = [NSURL URLWithString:@"http://izvestia.ru/xml/rss/politics.xml"];
        NSData *urlData = [NSData dataWithContentsOfURL:URL];
        NSParameterAssert(urlData);
        
        TBXML *xml = [TBXML tbxmlWithXMLData:urlData error:nil];
        
        TBXMLElement *root = xml.rootXMLElement;
        TBXMLElement *channel = [TBXML childElementNamed:@"channel" parentElement:root];
        
        for (TBXMLElement *item = [TBXML childElementNamed:@"item" parentElement:channel]; item;
             item = [TBXML nextSiblingNamed:@"item" searchFromElement:item])
        {
            TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:item];
            NSString *itemName = [TBXML textForElement:title];
            [_titles addObject:itemName];
            
            TBXMLElement *description = [TBXML nextSiblingNamed:@"description" searchFromElement:title];
            
            TBXMLElement *link = [TBXML nextSiblingNamed:@"link" searchFromElement:description];
            NSString *anLink = [TBXML textForElement:link];
            [_links addObject:anLink];
            
            NSLog(@"%@\n%@", itemName, anLink);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _animateIndicator = NO;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - TableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_titles.count == 0) {
        return 15;
    } else {
        return _titles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (_titles.count != 0) {
        UILabel *textLabel = (UILabel *)[cell viewWithTag:kTextlabelTag];
        textLabel.text = _titles[indexPath.row];
    }
    
    if (_animateIndicator) {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell viewWithTag:kActivityIndicatorTag];
        [activityIndicator startAnimating];
    } else {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell viewWithTag:kActivityIndicatorTag];
        [activityIndicator stopAnimating];
        activityIndicator.hidesWhenStopped = YES;
    }

    return cell;
}

#pragma mark - TableViewDelegate - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ShowDetail" sender:indexPath];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        RSSDetailViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = sender;
        controller.link = _links[indexPath.row];
        controller.title = _titles[indexPath.row];
    }
}

#pragma mark - RSSDetailViewControllerDelegate -

- (void)rssDetailViewController:(RSSDetailViewController *)controller showPreviousNewsBeforeCurrent:(NSString *)link
{
    NSInteger currentIndexOfLink;
    if ([link isEqualToString:@"End"]) {
        currentIndexOfLink = _titles.count - 1;
    } else {
        currentIndexOfLink = [_links indexOfObject:link];
    }
    
    if (currentIndexOfLink == 0 ||
        [link isEqualToString:@"TheBeginning"]) {
        controller.link = @"TheBeginning";
    } else {
        controller.link = _links[currentIndexOfLink - 1];
    }
}

- (void)rssDetailViewController:(RSSDetailViewController *)controller showNextNewsAfterCurrent:(NSString *)link
{
    NSInteger currentIndexOfLink;
    if ([link isEqualToString:@"TheBeginning"]) {
        currentIndexOfLink = 0;
    } else {
        currentIndexOfLink = [_links indexOfObject:link];
    }
    if (_titles.count == (currentIndexOfLink + 1) ||
        [link isEqualToString:@"End"]) {
        controller.link = @"End";
    } else {
        controller.link = _links[currentIndexOfLink + 1];
    }

}


@end
