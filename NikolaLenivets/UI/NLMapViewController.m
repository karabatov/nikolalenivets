//
//  NLMapViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMapViewController.h"
#import "NLMainMenuController.h"

@implementation NLMapViewController
{
    UIImageView *_currentLocationMarker;
    CLLocation *_leftUpperCornerLocation;
    CLLocation *_rightBottomCornerLocation;

    NSArray *_places;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init
{
    self = [super initWithNibName:@"NLMapViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NLUserLocationUpdated object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaces) name:STORAGE_DID_UPDATE object:nil];

        _leftUpperCornerLocation = [[CLLocation alloc] initWithLatitude:54.749725 longitude:35.600477];
        _rightBottomCornerLocation = [[CLLocation alloc] initWithLatitude:54.75782 longitude:35.60123];

        _currentLocationMarker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userlocation.png"]];
        _currentLocationMarker.frame = CGRectMake(0, 0, 37/2, 50);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapScrollView.contentSize = self.mapImageView.frame.size;
    self.mapScrollView.minimumZoomScale = 0.3;
    self.mapScrollView.maximumZoomScale = 2.0;

    [self.mapImageView addSubview:_currentLocationMarker];
    [self updatePlaces];
}


- (void)updatePlaces
{
    _places = [[NLStorage sharedInstance] places];
    [self redraw];
}

#pragma mark - Map-like stuff

- (void)cleanMap
{
    for (UIView *v in self.mapImageView.subviews) {
        [v removeFromSuperview];
    }
}

- (void)redraw
{
    [self cleanMap];

    if (self.currentLocation) {
        CGPoint currentLocation = [self pointFromLocation:self.currentLocation];
        _currentLocationMarker.center = CGPointMake(currentLocation.x,
                                                    currentLocation.y - _currentLocationMarker.frame.size.height / 2);
    }

    for (NLPlace *place in _places) {
        [self drawPlace:place];
    }
}


- (void)drawPlace:(NLPlace *)place
{
    CGPoint center = [self pointFromLocation:place.location];
    UIButton *placeButton = [[UIButton alloc] init];
    [placeButton setImage:[UIImage imageNamed:@"object.png"] forState:UIControlStateNormal];
    [placeButton sizeToFit];
    placeButton.center = center;
    [self.mapImageView addSubview:placeButton];
}

#pragma mark - Location Stuff

- (void)locationUpdated:(NSNotification *)notification
{
    self.currentLocation = notification.object;
    [self redraw];
}


- (CGPoint)pointFromLocation:(CLLocation *)location
{
    CGPoint point = CGPointMake(0, 0);

#warning Implement me

    double latDelta = _leftUpperCornerLocation.coordinate.latitude  - _rightBottomCornerLocation.coordinate.latitude;
    double lonDelta = _leftUpperCornerLocation.coordinate.longitude - _rightBottomCornerLocation.coordinate.longitude;

    double latPPD = fabs((double)self.mapImageView.frame.size.width / latDelta);
    double lonPPD = fabs((double)self.mapImageView.frame.size.height / lonDelta);

    double locationLatDelta = fabs((double)_leftUpperCornerLocation.coordinate.latitude - location.coordinate.latitude);
    double locationLonDelta = fabs((double)_leftUpperCornerLocation.coordinate.longitude - location.coordinate.longitude);

    double x = locationLatDelta * latPPD;
    double y = locationLonDelta * lonPPD;

    point.x = x;
    point.y = y;

    return point;
}



#pragma mark - Scrolling delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
}

@end
