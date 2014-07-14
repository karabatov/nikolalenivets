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

@implementation NLPlacesViewController
{
    NSArray *_placesPairs;
    NSArray *_places;
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
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:@"МЕСТА"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NLPlaceCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"NLPlaceCell"];
    [self updatePlaces];

}


- (void)updateUnreadCount
{
    self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)[[NLStorage sharedInstance] unreadCountInArray:_places]];
}


- (void)updatePlaces
{
    _places = [[NLStorage sharedInstance] places];
    [self updateUnreadCount];

    NSMutableArray *pairs = [NSMutableArray new];

    for (NSUInteger i = 0; i < _places.count; i += 2) {
        NSMutableArray *pair = [NSMutableArray new];
        [pair addObject:_places[i]];
        if (i + 1 < _places.count) {
            [pair addObject:_places[i + 1]];
        }
        [pairs addObject:pair];
    }

    _placesPairs = pairs;

    [self.collectionView reloadData];
}


- (NLPlace *)placeForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pair = _placesPairs[indexPath.section];

    if (pair.count <= indexPath.item) {
        return nil;
    }

    return pair[indexPath.item];
}


#pragma mark - Collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _placesPairs.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLPlaceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NLPlaceCell" forIndexPath:indexPath];

    if (indexPath.section < _placesPairs.count) {
        NLPlace *place = [self placeForIndexPath:indexPath];
        [cell populateWithPlace:place];
        // TODO: km, m and “You are here!”
        if (_userLoc) {
            CLLocationDistance distance = [place distanceFromLocation:_userLoc];
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f КМ", distance / 1000];
        }
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < _placesPairs.count) {
        NLPlace *place = [self placeForIndexPath:indexPath];
        if (place == nil) {
            return;
        }
        NLDetailsViewController *details = [[NLDetailsViewController alloc] initWithPlace:place currentLocation:_userLoc];
        [self presentViewController:details animated:YES completion:^{
            [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
            [self updateUnreadCount];
        }];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}

@end
