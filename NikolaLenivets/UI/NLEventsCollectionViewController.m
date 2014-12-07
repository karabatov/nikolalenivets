//
//  NLEventsCollectionViewController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEventsCollectionViewController.h"
#import "NLDetailsViewController.h"
#import "NLStorage.h"
#import "NLMainMenuController.h"
#import "NSAttributedString+Kerning.h"
#import "NSDate+Helper.h"
#import "Underscore.h"
#import "NLCollectionCell.h"
#import "NLSectionHeader.h"
#import "NSString+Ordinal.h"
#import "NSDate+CompareDays.h"
#import "NLFlowLayout.h"
#import "UIViewController+CustomButtons.h"

@implementation NLEventsCollectionViewController
{
    __strong NLEventGroup *_group;
    __strong NLDetailsViewController *_details;
    __strong NSDate *_startDate;
    __strong NSDate *_endDate;
    __strong NSMutableArray *_eventsByDay;
    __strong NSMutableDictionary *_sizeCache;
    NSInteger _days;
}


- (instancetype)initWithGroup:(NLEventGroup *)group
{
    self = [super initWithNibName:@"NLEventsCollectionViewController" bundle:nil];
    if (self) {
        _group = group;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareState) name:STORAGE_DID_UPDATE object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareState];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:NSLocalizedString(@"СОБЫТИЯ", @"EVENTS")];
    self.itemsCountLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9.0f];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[NLCollectionCell class] forCellWithReuseIdentifier:[NLCollectionCell reuseIdentifier]];
    [self.collectionView registerClass:[NLSectionHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLSectionHeader reuseSectionId]];
    NLFlowLayout *layout = [[NLFlowLayout alloc] init];
    layout.columnCount = 2;
    layout.headerHeight = 0.0f;
    layout.footerHeight = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumColumnSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    // NSUInteger unreadCount = [[NLStorage sharedInstance] unreadCountInArray:_group.events];
    // [self updateUnreadCountWithCount:unreadCount];
    [self setupForNavBarWithStyle:NLNavigationBarStyleBackLightMenu];
}


//- (void)updateUnreadCountWithCount:(NSInteger)unreadCount
//{
//    if (unreadCount == 0) {
//        self.titleBarHeight.constant = 52.0f;
//        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            [self.view layoutIfNeeded];
//            self.itemsCountLabel.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            [self.itemsCountLabel setHidden:YES];
//            self.itemsCountLabel.alpha = 1.0f;
//            self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)unreadCount];
//        }];
//    } else {
//        self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)unreadCount];
//        self.titleBarHeight.constant = 64.0f;
//        [self.itemsCountLabel setTransform:CGAffineTransformMakeScale(0.05f, 0.05f)];
//        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            [self.itemsCountLabel setHidden:NO];
//            self.itemsCountLabel.alpha = 1.0f;
//            [self.itemsCountLabel setTransform:CGAffineTransformIdentity];
//            [self.view layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            //
//        }];
//    }
//}


- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)prepareState
{
    _startDate = [NSDate dateFromString:_group.startdate];
    _endDate = [NSDate dateFromString:_group.enddate];
    _days = [NSDate daysBetween:_startDate andDate:_endDate];
    _eventsByDay = [[NSMutableArray alloc] initWithCapacity:[_group.events count]];
    for (NSInteger i = 0; i < _days; i++) {
        NSArray *eventsThatDay = _.array(_group.events)
            .filter(^BOOL (NLEvent *event){
                NSDate *day = [_startDate dateByAddingTimeInterval:(i * 86400)];
                NSDate *compare = [event.startDate copy];
                [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&day interval:NULL forDate:day];
                [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&compare interval:NULL forDate:compare];
                return [day isEqualToDate:compare] ? YES : NO;
            }).unwrap;
        [_eventsByDay addObject:eventsThatDay];
    }
}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NLEvent *)eventForIndexPath:(NSIndexPath *)indexPath
{
    return _eventsByDay[indexPath.section][indexPath.item];
}


#pragma mark - UICollectionViewDataSource


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLEvent *event = [self eventForIndexPath:indexPath];
    _details = [[NLDetailsViewController alloc] initWithEvent:event withOrderInGroup:indexPath.section + 1];
    _details.title = [_group.name uppercaseString];
    [self.navigationController pushViewController:_details animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
        // [self updateUnreadCountWithCount:[[NLStorage sharedInstance] unreadCountInArray:_group.events]];
    });
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLCollectionCell *cell = (NLCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NLCollectionCell reuseIdentifier] forIndexPath:indexPath];
    NLEvent *event = [self eventForIndexPath:indexPath];
    [cell populateFromEvent:event];
    cell.counterLabel.text = [NSString stringWithFormat:@"%02lu", (unsigned long)indexPath.item + 1];
    UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [cell.layer setBorderColor:borderGray.CGColor];
    [cell.layer setBorderWidth:0.5f];

    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_eventsByDay[section] count];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        NLSectionHeader *sectionView = (NLSectionHeader *)[self.collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLSectionHeader reuseSectionId] forIndexPath:indexPath];
        if (!sectionView) {
            sectionView = [[NLSectionHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 26.0f)];
        }
        if ([_eventsByDay[indexPath.section] count] != 0) {
            NLEvent *event = [_eventsByDay[indexPath.section] firstObject];
            sectionView.dateLabel.text = [[[event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            sectionView.dayOrderLabel.text = [[NSString stringWithFormat:NSLocalizedString(@"%@ %@", @"Ordinal day string format"), NSLocalizedString(@"день", @"Ordinal day - day string"), [NSString ordinalRepresentationWithNumber:indexPath.section + 1]] uppercaseString];
        }
        return sectionView;
    } else {
        return nil;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _days;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    if ([_eventsByDay[section] count] != 0) {
        return 26.0f;
    } else {
        return 0.0f;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_sizeCache) {
        _sizeCache = [[NSMutableDictionary alloc] init];
    }
    CGFloat height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.0f;
    CGSize cellSize;
    if (![_sizeCache objectForKey:indexPath]) {
        NLEvent *event = [self eventForIndexPath:indexPath];
        height = [NLCollectionCell heightForCellWithEvent:event];
        [_sizeCache setObject:[NSNumber numberWithFloat:height] forKey:indexPath];
    } else {
        height = [[_sizeCache objectForKey:indexPath] floatValue];
    }
    cellSize = CGSizeMake(width, height);
    return cellSize;
}

@end
