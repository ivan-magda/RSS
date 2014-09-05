//
//  ViewController.m
//  RSS
//
//  Created by Ivan Magda on 05.09.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "RSStableViewController.h"

#import <TBXML/TBXML.h>

@interface RSStableViewController ()

@end

@implementation RSStableViewController {
    NSMutableArray *_titles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titles = [[NSMutableArray alloc]initWithCapacity:30];
    
    [self parseXML];
}

- (void)parseXML {
    NSURL *URL = [NSURL URLWithString:@"http://izvestia.ru/xml/rss/politics.xml"];
    NSData *urlData = [NSData dataWithContentsOfURL:URL];
    NSParameterAssert(urlData);
    
    TBXML *xml = [TBXML tbxmlWithXMLData:urlData error:nil];
    
    TBXMLElement *root = xml.rootXMLElement;
    TBXMLElement *channel = [TBXML childElementNamed:@"channel" parentElement:root];
    
    for (TBXMLElement *item = [TBXML childElementNamed:@"item" parentElement:channel];
         item != nil;
         item = [TBXML nextSiblingNamed:@"item" searchFromElement:item])
    {
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:item];
        NSString *itemName = [TBXML textForElement:title];
        
        [_titles addObject:itemName];
        NSLog(@"%@", itemName);
    }
}


#pragma mark - TableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

@end
