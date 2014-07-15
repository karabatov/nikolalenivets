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

@implementation NLEventsCollectionViewController
{
    __strong NLEventGroup *_group;
    __strong NLDetailsViewController *_details;
    __strong NSDate *_startDate;
    __strong NSDate *_endDate;
    __strong NSMutableArray *_eventsByDay;
    NSInteger _days;
}


static NSString *const reuseId = @"collectioncell";
static NSString *const reuseSectionId = @"collectionsection";


- (instancetype)initWithGroup:(NLEventGroup *)group
{
    self = [super initWithNibName:@"NLEventsCollectionViewController" bundle:nil];
    if (self) {
        _group = group;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareState];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:@"СОБЫТИЯ"];
    self.itemsCountLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9.0f];
    self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)[[NLStorage sharedInstance] unreadCountInArray:_group.events]];

    [self.collectionView registerNib:[UINib nibWithNibName:@"NLCollectionCellView" bundle:nil] forCellWithReuseIdentifier:reuseId];
    [self.collectionView registerClass:[NLSectionHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:reuseSectionId];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 2;
    layout.headerHeight = 0.0f;
    layout.footerHeight = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumColumnSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}


- (void)prepareState
{
    _startDate = [NSDate dateFromString:_group.startdate];
    _endDate = [NSDate dateFromString:_group.enddate];
    _days = [self daysBetween:_startDate andDate:_endDate];
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


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (NLEvent *)eventForIndexPath:(NSIndexPath *)indexPath
{
    return _eventsByDay[indexPath.section][indexPath.item];
}


- (NSInteger)daysBetween:(NSDate *)dt1 andDate:(NSDate *)dt2
{
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    NSInteger daysBetween = llabs([components day]);
    return daysBetween + 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLEvent *event = [self eventForIndexPath:indexPath];
    _details = [[NLDetailsViewController alloc] initWithEvent:event];
    [self presentViewController:_details animated:YES completion:^{
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }];
}


#pragma mark - UICollectionViewDataSource


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLCollectionCell *cell = (NLCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLCollectionCellView" owner:self options:nil] firstObject];
    }

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
        NLSectionHeader *sectionView = (NLSectionHeader *)[self.collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:reuseSectionId forIndexPath:indexPath];
        if (!sectionView) {
            sectionView = [[NLSectionHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 26.0f)];
        }
        if ([_eventsByDay[indexPath.section] count] != 0) {
            NLEvent *event = [_eventsByDay[indexPath.section] firstObject];
            sectionView.dateLabel.text = [[[event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            sectionView.dayOrderLabel.text = [[NSString stringWithFormat:@"%@ %@", @"день", [NSString ordinalRepresentationWithNumber:indexPath.section + 1]] uppercaseString];
            UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
            [sectionView.layer setBorderColor:borderGray.CGColor];
            [sectionView.layer setBorderWidth:0.5f];
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
    NLEvent *event = [self eventForIndexPath:indexPath];
    CGSize cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2.0f, [NLCollectionCell heightForCellWithEvent:event]);
    return cellSize;
}

@end
