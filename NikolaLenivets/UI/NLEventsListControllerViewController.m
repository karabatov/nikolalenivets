//
//  NLEventsListControllerViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEventsListControllerViewController.h"
#import "NLEvent.h"
#import "NLNewsCell.h"
#import "NLNewsListController.h"
#import "NLDetailsViewController.h"

@implementation NLEventsListControllerViewController
{
    __strong NLEventGroup *_group;
    __strong NSMutableArray *_leftGroup;
    __strong NSMutableArray *_rightGroup;
    __strong NLDetailsViewController *_details;
}

- (id)initWithGroup:(NLEventGroup *)group;
{
    self = [super initWithNibName:@"NLEventsListControllerViewController" bundle:nil];
    if (self) {
        _group = group;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    [self prepareEventArrays];
}


#pragma mark - Actions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - Grouping

- (void)prepareEventArrays
{
    _leftGroup = [NSMutableArray new];
    _rightGroup = [NSMutableArray new];

    NSArray *events = _group.events;

    for (int i = 0; i < events.count; i++) {
        if (i % 2 == 0) {
            [_leftGroup addObject:events[i]];
        } else {
            [_rightGroup addObject:events[i]];
        }
    }
    [self.leftTable reloadData];
    [self.rightTable reloadData];
}


#pragma mark - Tables stuff

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLEvent *event = [self entryForTable:tableView indexPath:indexPath];
    return [NLNewsCell heightForCellWithEvent:event];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case LeftTable:
            return _leftGroup.count;
            break;
        case RightTable:
            return _rightGroup.count;
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

    NLEvent *event = [self entryForTable:tableView indexPath:indexPath];
    [cell populateFromEvent:event];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NLEvent *event = [self entryForTable:tableView indexPath:indexPath];
    _details = [[NLDetailsViewController alloc] initWithEvent:event];
    [self presentViewController:_details animated:YES completion:^{}];
}


#pragma mark - Utils

- (NLEvent *)entryForTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath
{
    NLEvent *entry = nil;
    switch (table.tag) {
        case LeftTable:
            entry = _leftGroup[indexPath.row];
            break;
        case RightTable:
            entry = _rightGroup[indexPath.row];
            break;
        default:
            NSAssert(0, @"Something strange happened!");
            break;
    }
    return entry;
}


@end
