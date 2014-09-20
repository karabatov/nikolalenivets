//
//  NLNewsListController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 24.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLItemsListController.h"
#import "NLMainMenuController.h"
#import "NLNewsCell.h"
#import "NLDetailsViewController.h"
#import "NSAttributedString+Kerning.h"
#import "UIViewController+CustomButtons.h"


@implementation NLItemsListController
{
    __strong NSArray *_news;
    __strong NSMutableArray *_leftNews;
    __strong NSMutableArray *_rightNews;
    __strong NLDetailsViewController *_details;
}

- (id)init
{
    self = [super initWithNibName:@"NLItemsListController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareArrays) name:STORAGE_DID_UPDATE object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *bgColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.view setBackgroundColor:bgColor];
    if ([self.leftTable respondsToSelector:@selector(setEstimatedRowHeight:)]) {
        [self.leftTable setEstimatedRowHeight:315.0f];
        [self.rightTable setEstimatedRowHeight:315.0f];
    }
    [self.leftTable registerClass:[NLNewsCell class] forCellReuseIdentifier:[NLNewsCell reuseIdentifier]];
    [self.rightTable registerClass:[NLNewsCell class] forCellReuseIdentifier:[NLNewsCell reuseIdentifier]];
    self.leftTable.separatorInset = self.rightTable.separatorInset = UIEdgeInsetsZero;
    self.leftTable.separatorStyle = self.rightTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.leftTable.separatorColor = self.rightTable.separatorColor = bgColor;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:159.5f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightTable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:159.5f]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareArrays];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.rightTable.contentInset.top != self.leftTable.contentInset.top) {
        self.rightTable.contentInset = self.leftTable.contentInset;
        [self.rightTable setContentOffset:CGPointMake(0, -self.rightTable.contentInset.top) animated:YES];
    }
}


#pragma mark - News processing

- (void)prepareArrays
{
    _leftNews = [NSMutableArray new];
    _rightNews = [NSMutableArray new];
    
    NSArray *news = [[NLStorage sharedInstance] news];
    _news = news;
    
    for (int i = 0; i < news.count; i++) {
        if (i % 2 == 0) {
            [_leftNews addObject:news[i]];
        } else {
            [_rightNews addObject:news[i]];
        }
    }
    [self updateUnreadCountWithCount:[[NLStorage sharedInstance] unreadCountInArray:_news]];
    [self.leftTable reloadData];
    [self.rightTable reloadData];
}

#pragma mark - Table Stuff

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLNewsEntry *entry = [self entryForTable:tableView indexPath:indexPath];
    return [NLNewsCell heightForCellWithEntry:entry];
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
    NLNewsCell *cell = (NLNewsCell *)[tableView dequeueReusableCellWithIdentifier:[NLNewsCell reuseIdentifier]];
    
    NLNewsEntry *entry = [self entryForTable:tableView indexPath:indexPath];
    [cell populateFromNewsEntry:entry];
    cell.counterLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)([_news count] - [_news indexOfObject:entry])];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NLNewsEntry *entry = [self entryForTable:tableView indexPath:indexPath];
    _details = [[NLDetailsViewController alloc] initWithEntry:entry];
    _details.title = @"НОВОСТИ";
    [self.navigationController pushViewController:_details animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateUnreadCountWithCount:[[NLStorage sharedInstance] unreadCountInArray:_news]];
    });
}


#pragma mark - Utils 


- (void)updateUnreadCountWithCount:(NSInteger)unreadCount
{
    ((NLNavigationBar *)self.navigationController.navigationBar).counter = unreadCount;
    if (unreadCount == 0) {
        [self setupForNavBarWithStyle:NLNavigationBarStyleNoCounter];
    } else {
        [self setupForNavBarWithStyle:NLNavigationBarStyleCounter];
    }
}


- (NLNewsEntry *)entryForTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath
{
    NLNewsEntry *entry = nil;
    switch (table.tag) {
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
    return entry;
}


- (void)makeVisibleImagesGrayscale:(BOOL)grayscale forTableview:(UITableView *)tableView
{
    for (NLNewsCell *cell in [tableView visibleCells]) {
        [cell makeImageGrayscale:grayscale];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.leftTable]) {
        self.rightShadowView.hidden = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.rightShadowView.alpha = 1.f;
            self.rightTable.alpha = 0.5f;
        }];
        [self.rightTable setUserInteractionEnabled:NO];
        [self makeVisibleImagesGrayscale:YES forTableview:self.rightTable];
    }

    if ([scrollView isEqual:self.rightTable]) {
        self.leftShadowView.hidden = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.leftShadowView.alpha = 1.f;
            self.leftTable.alpha = 0.5f;
        }];
        [self.leftTable setUserInteractionEnabled:NO];
        [self makeVisibleImagesGrayscale:YES forTableview:self.leftTable];
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([scrollView isEqual:self.leftTable]) {
        [UIView animateWithDuration:0.25f animations:^{
            self.rightShadowView.alpha = 0.f;
            self.rightTable.alpha = 1.f;
        } completion:^(BOOL finished) {
            self.rightShadowView.hidden = YES;
        }];
    }

    if ([scrollView isEqual:self.rightTable]) {
        [UIView animateWithDuration:0.25f animations:^{
            self.leftShadowView.alpha = 0.f;
            self.leftTable.alpha = 1.f;
        } completion:^(BOOL finished) {
            self.leftShadowView.hidden = YES;
        }];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UITableView *anotherTableView = [scrollView isEqual:self.rightTable] ? self.leftTable : self.rightTable;
    [anotherTableView setUserInteractionEnabled:YES];
    [self makeVisibleImagesGrayscale:NO forTableview:anotherTableView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        UITableView *anotherTableView = [scrollView isEqual:self.rightTable] ? self.leftTable : self.rightTable;
        [anotherTableView setUserInteractionEnabled:YES];
        [self makeVisibleImagesGrayscale:NO forTableview:anotherTableView];
    }
}

@end
