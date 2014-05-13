//
//  NLNewsListController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 24.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsListController.h"
#import "NLMainMenuController.h"
#import "NLNewsCell.h"

enum  {
    LeftTable  = 0,
    RightTable = 1
};


@implementation NLNewsListController
{
    __strong NSMutableArray *_leftNews;
    __strong NSMutableArray *_rightNews;
}

- (id)init
{
    self = [super initWithNibName:@"NLNewsListController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareNewsArrays) name:STORAGE_DID_UPDATE object:nil];
    }
    return self;
}


- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareNewsArrays];
}

#pragma mark - News processing

- (void)prepareNewsArrays
{
    _leftNews = [NSMutableArray new];
    _rightNews = [NSMutableArray new];
    
    NSArray *news = [[NLStorage sharedInstance] news];
    
    for (int i = 0; i < news.count; i++) {
        if (i % 2 == 0) {
            [_leftNews addObject:news[i]];
        } else {
            [_rightNews addObject:news[i]];
        }
    }
    [self.leftTable reloadData];
    [self.rightTable reloadData];
}

#pragma mark - Table Stuff

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 314.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case LeftTable:
            return _leftNews.count;
            break;
        case RightTable:
            return _rightNews.count;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"newscell";
    
    NLNewsCell *cell = (NLNewsCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLNewsCellView" owner:self options:nil] firstObject];
    }
    
    NLNewsEntry *entry = nil;
    switch (tableView.tag) {
        case LeftTable:
            entry = _leftNews[indexPath.row];
            break;
        case RightTable:
            entry = _rightNews[indexPath.row];
            break;
        default:
            NSAssert(0, @"Something strange happened!");
            break;
    }
    [cell populateFromNewsEntry:entry];
    return cell;
}

@end
