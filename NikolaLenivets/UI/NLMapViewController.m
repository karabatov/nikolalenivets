//
//  NLMapViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMapViewController.h"
#import "NLMainMenuController.h"
#import "NSAttributedString+Kerning.h"
#import "NLPlaceAnnotation.h"

#define MaxZoom  2.0
#define MinZoom  0.5
#define ZoomStep 0.5

@implementation NLMapViewController
{
    MKTileOverlay *_tileOverlay;
    UIImageView *_currentLocationMarker;
    CLLocation *_leftUpperCornerLocation;
    CLLocation *_rightBottomCornerLocation;
    MKAnnotationView *_selectedView;
    BOOL _shouldResetSelectedView;
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

        // _leftUpperCornerLocation = [[CLLocation alloc] initWithLatitude:54.749725 longitude:35.600477];
        // _rightBottomCornerLocation = [[CLLocation alloc] initWithLatitude:54.75782 longitude:35.60123];

        // _currentLocationMarker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userlocation.png"]];
        // _currentLocationMarker.frame = CGRectMake(0, 0, 37/2, 50);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[AppDelegate window] frame];

    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:@"КАРТА"];

    // self.mapScrollView.contentSize = self.mapImageView.frame.size;
    // self.mapScrollView.minimumZoomScale = MinZoom;
    // self.mapScrollView.maximumZoomScale = MaxZoom;

    // [self.mapImageView addSubview:_currentLocationMarker];
    [self.mapView addSubview:self.placeDetailsMenu];
    [self.placeDetailsMenu setHidden:YES];
    self.placeDetailsMenu.alpha = 0.0f;
    [self.placeDetailsMenu setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.placeDetailsMenu attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-6.0f];
    NSLayoutConstraint *bottomY = [NSLayoutConstraint constraintWithItem:self.placeDetailsMenu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-180.0f];
    [self.view addConstraints:@[ centerX, bottomY ]];

    [self.placeUnreadIndicator setHidden:YES];
    self.placeInfoIconsHeight.constant = 0;
    self.placeName.font = [UIFont fontWithName:NLMonospacedBoldFont size:13];
    self.distanceToPlace.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.distanceToPlaceLegend.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];

    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(54.7555, 35.6113), MKCoordinateSpanMake(0.0333783, 0.0367246));
    self.mapView.mapType = MKMapTypeStandard;

    NSString *baseURL = [[[NSBundle mainBundle] bundleURL] absoluteString];
    NSString *urlTemplate = [baseURL stringByAppendingString:@"tiles/{z}/{x}/{y}.png"];
    _tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:urlTemplate];
    _tileOverlay.canReplaceMapContent = YES;
    _tileOverlay.minimumZ = 12;
    _tileOverlay.maximumZ = 16;
    _tileOverlay.geometryFlipped = YES;
    [self.mapView addOverlay:_tileOverlay level:MKOverlayLevelAboveLabels];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    [self updatePlaces];
}


- (void)updatePlaces
{
    _places = [[NLStorage sharedInstance] places];
    for (NLPlace *place in _places) {
        NLPlaceAnnotation *annotation = [[NLPlaceAnnotation alloc] initWithPlace:place];
        [self.mapView addAnnotation:annotation];
    }
}

#pragma mark - Map-like stuff

- (void)clearMap
{
//    for (UIView *v in self.mapImageView.subviews) {
//        [v removeFromSuperview];
//    }
}


- (void)showPlaceMenu:(NLPlaceAnnotation *)sender
{
    NLPlace *place = sender.place;

    NSLog(@"PLACE: %@", place.title);

    if (self.placeDetailsMenu.hidden == NO) {
        self.placeDetailsMenu.hidden = YES;
        self.placeDetailsMenu.alpha = 0.0f;
    }

    [self showLocation:place.location];

    self.placeName.text = [place.title uppercaseString];
    // if (_currentLocation) {
    //     self.distanceToPlace.text = [NSString stringWithFormat:@"%.2f км.", [place distanceFromLocation:_currentLocation] / 100];
    // }

    [UIView animateWithDuration:0.25 delay:0.4f usingSpringWithDamping:0.5 initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeDetailsMenu.hidden = NO;
        self.placeDetailsMenu.alpha = 1.0;
    } completion:NULL];
}


- (void)showLocation:(CLLocation *)location
{
//    CGPoint placeCenter = [self pointFromLocation:location];
//    placeCenter = [self.resizableView convertPoint:placeCenter toView:self.mapScrollView];
//
//    [self.mapScrollView scrollRectToVisible:CGRectMake(placeCenter.x - self.view.frame.size.width / 2,
//                                                       placeCenter.y - self.view.frame.size.height / 2 - 80,
//                                                       self.view.frame.size.width,
//                                                       self.view.frame.size.height) animated:YES];
}



- (void)hidePlaceMenu
{
    [UIView animateWithDuration:0.2 animations:^{
        self.placeDetailsMenu.alpha = 0.0;
        self.placeDetailsMenu.hidden = YES;
    }];
}


#pragma mark - Location Stuff

- (void)locationUpdated:(NSNotification *)notification
{
    self.currentLocation = notification.object;
    // [self redraw];
}


- (CGPoint)pointFromLocation:(CLLocation *)location
{
//    CGPoint point = CGPointMake(0, 0);
//
//    double latDelta = _leftUpperCornerLocation.coordinate.latitude  - _rightBottomCornerLocation.coordinate.latitude;
//    double lonDelta = _leftUpperCornerLocation.coordinate.longitude - _rightBottomCornerLocation.coordinate.longitude;
//
//    double latPPD = fabs((double)self.mapScrollView.contentSize.width / latDelta);
//    double lonPPD = fabs((double)self.mapScrollView.contentSize.height / lonDelta);
//
//    double locationLatDelta = fabs((double)_leftUpperCornerLocation.coordinate.latitude - location.coordinate.latitude);
//    double locationLonDelta = fabs((double)_leftUpperCornerLocation.coordinate.longitude - location.coordinate.longitude);
//
//    double x = (locationLatDelta * latPPD) / self.mapScrollView.zoomScale;
//    double y = (locationLonDelta * lonPPD) / self.mapScrollView.zoomScale;;
//
//    point.x = x;
//    point.y = y;

    return CGPointZero;
}


#pragma mark - Actions

- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}


- (IBAction)zoomIn:(id)sender
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = self.mapView.region.center;
    span.latitudeDelta = self.mapView.region.span.latitudeDelta / 1.5;
    span.longitudeDelta = self.mapView.region.span.longitudeDelta / 1.5;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}


- (IBAction)zoomOut:(id)sender
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = self.mapView.region.center;
    span.latitudeDelta = self.mapView.region.span.latitudeDelta * 1.5;
    span.longitudeDelta = self.mapView.region.span.longitudeDelta * 1.5;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}


- (IBAction)showMyLocation:(id)sender
{
    if (_currentLocation) {
        [self showLocation:_currentLocation];
    }
}


#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithOverlay:_tileOverlay];
    } else {
        return nil;
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *userReuseId = @"com.nikola-lenivets.annotation.user";
    static NSString *placeReuseId = @"com.nikola-lenivets.annotation.place";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *userLocationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userReuseId];
        if (!userLocationView) {
            userLocationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userReuseId];
            userLocationView.image = [UIImage imageNamed:@"userlocation.png"];
            userLocationView.centerOffset = CGPointMake(0, userLocationView.centerOffset.y - userLocationView.image.size.height / 2);
        }
        return userLocationView;
    } else if ([annotation isKindOfClass:[NLPlaceAnnotation class]]) {
        MKAnnotationView *placeLocationView = [mapView dequeueReusableAnnotationViewWithIdentifier:placeReuseId];
        if (!placeLocationView) {
            placeLocationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placeReuseId];
            placeLocationView.image = [UIImage imageNamed:@"object.png"];
            placeLocationView.centerOffset = CGPointMake(0, placeLocationView.centerOffset.y - placeLocationView.image.size.height / 2);
        }
        return placeLocationView;
    } else {
        return nil;
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"selected view with coordinate lat %g, lon %g", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
    if ([view.annotation isKindOfClass:[NLPlaceAnnotation class]]) {
        if (_selectedView) {
            [_selectedView setSelected:NO];
            _selectedView.image = [UIImage imageNamed:@"object.png"];
        }
        _selectedView = view;
        view.image = [UIImage imageNamed:@"object-selected.png"];
        CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude + 0.0025f, view.annotation.coordinate.longitude);
        MKCoordinateRegion region = {.center = newCenter, .span = MKCoordinateSpanMake(0.01, 0.01)};
        _shouldResetSelectedView = NO;
        [mapView setRegion:region animated:YES];
        _shouldResetSelectedView = YES;
        [self showPlaceMenu:view.annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[NLPlaceAnnotation class]]) {
        view.image = [UIImage imageNamed:@"object.png"];
        [self hidePlaceMenu];
    }
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (_selectedView && _shouldResetSelectedView) {
        [_selectedView setSelected:NO];
        _selectedView.image = [UIImage imageNamed:@"object.png"];
        [self hidePlaceMenu];
    }
}

@end
