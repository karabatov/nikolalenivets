//
//  NLPlacesViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlacesViewController.h"
#import "NLStorage.h"
#import "NLPlaceCell.h"
#import "NLDetailsViewController.h"
#import "NLMainMenuController.h"
#import "NSAttributedString+Kerning.h"
#import "NSString+Distance.h"
#import "NLPlaceHeader.h"
#import "NLCategory.h"
#import <Underscore.h>

@implementation NLPlacesViewController
{
    NSArray *_places;
    NSArray *_categories;
    NSMutableArray *_catPlaces;
    CLLocation *_userLoc;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init
{
    self = [super initWithNibName:@"NLPlacesViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaces) name:STORAGE_DID_UPDATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NLUserLocationUpdated object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:@"МЕСТА"];
    self.itemsCountLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    [self.collectionView registerClass:[NLPlaceCell class] forCellWithReuseIdentifier:[NLPlaceCell reuseIdentifier]];
    [self.collectionView registerClass:[NLPlaceHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLPlaceHeader reuseSectionId]];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self updatePlaces];
}


- (void)updateUnreadCount
{
    NSInteger unreadCount = [[NLStorage sharedInstance] unreadCountInArray:_places];
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


- (void)updatePlaces
{
    _places = [[NLStorage sharedInstance] places];
    if (!_catPlaces) {
        _catPlaces = [[NSMutableArray alloc] init];
    } else {
        [_catPlaces removeAllObjects];
    }
    [self updateUnreadCount];

    _categories = _.array(_places)
        .map(^(NLPlace *place){
            return place.categories;
        })
        .flatten
        .uniq
        .unwrap;

    for (NLCategory *category in _categories) {
        NSArray *placesForCat = [[NSArray alloc] init];
        placesForCat = _.array(_places)
            .filter(^BOOL (NLPlace *place){
                return  [category.id isEqualToNumber:((NLCategory *)[place.categories firstObject]).id];
            }).unwrap;
        [_catPlaces addObject:placesForCat];
    }

    [self.collectionView reloadData];
    NLFlowLayout *layout = [[NLFlowLayout alloc] init];
    layout.columnCount = 2;
    layout.headerHeight = 0.0f;
    layout.footerHeight = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumColumnSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
}


- (NLPlace *)placeForIndexPath:(NSIndexPath *)indexPath
{
    return _catPlaces[indexPath.section][indexPath.item];
}


#pragma mark - Collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_categories count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_catPlaces[section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLPlaceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[NLPlaceCell reuseIdentifier] forIndexPath:indexPath];

    if (indexPath.section < [_categories count]) {
        NLPlace *place = [self placeForIndexPath:indexPath];
        [cell populateWithPlace:place];
        if (_userLoc) {
            CLLocationDistance distance = [place distanceFromLocation:_userLoc];
            cell.distanceLabel.text = [[NSString stringFromDistance:distance] uppercaseString];
        }
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [_categories count]) {
        NLPlace *place = [self placeForIndexPath:indexPath];
        if (place == nil) {
            return;
        }
        NLDetailsViewController *details = [[NLDetailsViewController alloc] initWithPlace:place currentLocation:_userLoc];
        self.title = @"МЕСТА";
        [((NLAppDelegate *)[[UIApplication sharedApplication] delegate]).navigation pushViewController:details animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
            [self updateUnreadCount];
        });
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        NLPlaceHeader *sectionView = (NLPlaceHeader *)[self.collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLPlaceHeader reuseSectionId] forIndexPath:indexPath];
        if (!sectionView) {
            sectionView = [[NLPlaceHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 50.0f)];
        }
        sectionView.objectCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)[_catPlaces[indexPath.section] count]];
        sectionView.categoryNameLabel.text = [((NLCategory *)(_categories[indexPath.section])).name uppercaseString];
        return sectionView;
    } else {
        return nil;
    }
}


- (void)locationUpdated:(NSNotification *)newLocation
{
    if (_userLoc == nil) {
        [self.collectionView reloadData];
    }
    _userLoc = newLocation.object;
}


- (IBAction)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
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
    return CGSizeMake(160, 194);
}

@end
