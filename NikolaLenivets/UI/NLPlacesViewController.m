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

@implementation NLPlacesViewController
{
    __strong NSArray *_places;
    __strong CLLocation *_userLoc;
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
    self.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NLPlaceCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"NLPlaceCell"];
    [self updatePlaces];

}


- (void)updatePlaces
{
    _places = [[NLStorage sharedInstance] places];
    self.itemsCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)_places.count];
    [self.collectionView reloadData];
}


#pragma mark - Collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _places.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLPlaceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NLPlaceCell" forIndexPath:indexPath];
    if (indexPath.row < _places.count) {
        NLPlace *place = _places[indexPath.row];
        [cell populateWithPlace:place];
        if (_userLoc) {
            CLLocationDistance distance = [place distanceFromLocation:_userLoc];
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f км.", distance / 1000];
        }
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _places.count) {
        NLPlace *place = _places[indexPath.row];
        NLDetailsViewController *details = [[NLDetailsViewController alloc] initWithPlace:place currentLocation:_userLoc];
        [self presentViewController:details animated:YES completion:^{}];
    }
}


- (void)locationUpdated:(NSNotification *)newLocation
{
    _userLoc = newLocation.object;
    [self.collectionView reloadData];
}


- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}

@end
