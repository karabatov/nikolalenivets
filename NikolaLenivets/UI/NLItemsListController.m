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


@implementation NLItemsListController
{
    __strong NSArray *_news;
    __strong NSMutableArray *_leftNews;
    __strong NSMutableArray *_rightNews;
    __strong NLDetailsViewController *_details;
    __strong NSMutableArray *_offsetQueueRight;
    __strong NSMutableArray *_offsetQueueLeft;
}

- (id)init
{
    self = [super initWithNibName:@"NLItemsListController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareArrays) name:STORAGE_DID_UPDATE object:nil];
    }
    return self;
}


- (IBAction)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:@"НОВОСТИ"];
    self.itemsCountLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9.0f];
    [self.leftTable setEstimatedRowHeight:315.0f];
    [self.rightTable setEstimatedRowHeight:315.0f];
    _offsetQueueRight = [[NSMutableArray alloc] init];
    _offsetQueueLeft = [[NSMutableArray alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareArrays];
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
    static NSString *reuseId = @"newscell";
    
    NLNewsCell *cell = (NLNewsCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLNewsCellView" owner:self options:nil] firstObject];
    }
    
    NLNewsEntry *entry = [self entryForTable:tableView indexPath:indexPath];
    [cell populateFromNewsEntry:entry];
    cell.counterLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)[_news indexOfObject:entry] + 1];
    UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [cell.contentView.layer setBorderColor:borderGray.CGColor];
    [cell.contentView.layer setBorderWidth:0.5f];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NLNewsEntry *entry = [self entryForTable:tableView indexPath:indexPath];
    _details = [[NLDetailsViewController alloc] initWithEntry:entry];
    self.title = @"НОВОСТИ";
    [((NLAppDelegate *)[[UIApplication sharedApplication] delegate]).navigation pushViewController:_details animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateUnreadCountWithCount:[[NLStorage sharedInstance] unreadCountInArray:_news]];
    });
}


#pragma mark - Utils 


- (void)updateUnreadCountWithCount:(NSInteger)unreadCount
{
    if (unreadCount == 0) {
        self.titleBarHeight.constant = 52.0f;
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
            self.itemsCountLabel.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.itemsCountLabel setHidden:YES];
            self.itemsCountLabel.alpha = 1.0f;
            self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)unreadCount];
        }];
    } else {
        self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)unreadCount];
        self.titleBarHeight.constant = 64.0f;
        [self.itemsCountLabel setTransform:CGAffineTransformMakeScale(0.05f, 0.05f)];
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.itemsCountLabel setHidden:NO];
            self.itemsCountLabel.alpha = 1.0f;
            [self.itemsCountLabel setTransform:CGAffineTransformIdentity];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            //
        }];
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.leftTable]) {
        self.rightShadowView.hidden = NO;
        [UIView animateWithDuration:0.1 animations:^{
            self.rightShadowView.alpha = 1.0;
        }];
        [self.rightTable setUserInteractionEnabled:NO];
    }

    if ([scrollView isEqual:self.rightTable]) {
        self.leftShadowView.hidden = NO;
        [UIView animateWithDuration:0.1 animations:^{
            self.leftShadowView.alpha = 1.0;
        }];
        [self.leftTable setUserInteractionEnabled:NO];
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([scrollView isEqual:self.leftTable]) {
        [UIView animateWithDuration:0.1 animations:^{
            self.rightShadowView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.rightShadowView.hidden = YES;
        }];
    }

    if ([scrollView isEqual:self.rightTable]) {
        [UIView animateWithDuration:0.1 animations:^{
            self.leftShadowView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.leftShadowView.hidden = YES;
        }];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.tracking || scrollView.dragging || scrollView.decelerating) && scrollView.userInteractionEnabled) {
        UITableView *anotherTableView = [scrollView isEqual:self.rightTable] ? self.leftTable : self.rightTable;
        NSMutableArray *offsetQueue = [scrollView isEqual:self.rightTable] ? _offsetQueueLeft : _offsetQueueRight;

        [offsetQueue addObject:[NSValue valueWithCGPoint:scrollView.contentOffset]];
        if ([offsetQueue count] > 4) {
            CGPoint newOffset = [(NSValue *)offsetQueue[0] CGPointValue];
            [offsetQueue removeObjectAtIndex:0];
            [anotherTableView setContentOffset:newOffset];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UITableView *anotherTableView = [scrollView isEqual:self.rightTable] ? self.leftTable : self.rightTable;
    NSMutableArray *offsetQueue = [scrollView isEqual:self.rightTable] ? _offsetQueueLeft : _offsetQueueRight;

    [anotherTableView setContentOffset:scrollView.contentOffset animated:YES];
    [offsetQueue removeAllObjects];
    [anotherTableView setUserInteractionEnabled:YES];
}

@end
