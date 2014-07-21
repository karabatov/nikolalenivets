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
#import "NSString+Distance.h"

@implementation NLMapViewController
{
    MKTileOverlay *_tileOverlay;
    UIImageView *_currentLocationMarker;
    CLLocation *_leftUpperCornerLocation;
    CLLocation *_rightBottomCornerLocation;
    MKAnnotationView *_selectedView;
    BOOL _shouldResetSelectedView;
    BOOL _manuallyChangingRegion;
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
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[AppDelegate window] frame];

    self.titleLabel.attributedText = [NSAttributedString kernedStringForString:@"КАРТА"];

    _shouldResetSelectedView = YES;

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

    MKTileOverlay *bgOverlay = [[MKTileOverlay alloc] initWithURLTemplate:[[[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"tile-empty.png"] absoluteString]];
    bgOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:bgOverlay level:MKOverlayLevelAboveRoads];
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


- (void)showPlaceMenu:(NLPlaceAnnotation *)sender
{
    NLPlace *place = sender.place;

    if (self.placeDetailsMenu.hidden == NO) {
        self.placeDetailsMenu.hidden = YES;
        self.placeDetailsMenu.alpha = 0.0f;
    }

    self.placeName.text = [place.title uppercaseString];
    if (_currentLocation) {
        self.distanceToPlaceHeight.constant = 14.0f;
        self.distanceToPlace.text = [[NSString stringFromDistance:[place distanceFromLocation:_currentLocation]] uppercaseString];
    } else {
        self.distanceToPlaceHeight.constant = 0.0f;
    }

    [UIView animateWithDuration:0.25 delay:0.4f usingSpringWithDamping:0.5 initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeDetailsMenu.hidden = NO;
        self.placeDetailsMenu.alpha = 1.0;
    } completion:NULL];
}


- (void)hidePlaceMenu
{
    [UIView animateWithDuration:0.25 delay:0.0f usingSpringWithDamping:0.5 initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeDetailsMenu.alpha = 0.0;
    } completion:^(BOOL finished){
        self.placeDetailsMenu.hidden = YES;
    }];
}


#pragma mark - Location Stuff

- (void)locationUpdated:(NSNotification *)notification
{
    self.currentLocation = notification.object;
}


#pragma mark - Actions

- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
    [self dismissViewControllerAnimated:NO completion:NULL];
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
    if (self.mapView.userLocation) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
}


#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
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
            placeLocationView.canShowCallout = NO;
            placeLocationView.enabled = YES;
        }
        return placeLocationView;
    } else {
        return nil;
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[NLPlaceAnnotation class]]) {
        if (_selectedView) {
            [self.mapView selectAnnotation:nil animated:NO];
            _selectedView.image = [UIImage imageNamed:@"object.png"];
        }
        _selectedView = view;
        view.image = [UIImage imageNamed:@"object-selected.png"];
        CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude + 0.0025f, view.annotation.coordinate.longitude);
        MKCoordinateRegion region = {.center = newCenter, .span = MKCoordinateSpanMake(0.01, 0.01)};
        _shouldResetSelectedView = NO;
        [mapView setRegion:region animated:YES];
        [self showPlaceMenu:view.annotation];
        _shouldResetSelectedView = YES;
    }
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[NLPlaceAnnotation class]]) {
        [self.mapView selectAnnotation:nil animated:NO];
        view.image = [UIImage imageNamed:@"object.png"];
    }
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (_selectedView && _shouldResetSelectedView) {
        [self.mapView selectAnnotation:nil animated:NO];
        _selectedView.image = [UIImage imageNamed:@"object.png"];
        [self hidePlaceMenu];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (_manuallyChangingRegion) {
        _manuallyChangingRegion = NO;
        return;
    }

    BOOL needToCenter = NO;

    if ((mapView.region.span.latitudeDelta > 0.04 ) || (mapView.region.span.longitudeDelta > 0.08) ) {
        needToCenter = YES;
    }
    if (fabs(fabs(mapView.region.center.latitude) - 54.755071) > 0.02) {
        needToCenter = YES;
    }
    if (fabs(fabs(mapView.region.center.longitude) - 35.620443) > 0.04) {
        needToCenter = YES;
    }

    if (needToCenter) {
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(54.755071, 35.620443);
        MKCoordinateSpan spanOfNL = MKCoordinateSpanMake(0.035162, 0.0367246);
        MKCoordinateRegion NLRegion = MKCoordinateRegionMake(centerCoord, spanOfNL);
        _manuallyChangingRegion = YES;
        [mapView setRegion:NLRegion animated:YES];
    }
}

@end
