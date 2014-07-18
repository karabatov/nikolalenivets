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

#define MaxZoom  2.0
#define MinZoom  0.5
#define ZoomStep 0.5

@implementation NLMapViewController
{
    MKTileOverlay *_tileOverlay;
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
    self.placeDetailsMenu.center = self.view.center;
    [self.view addSubview:self.placeDetailsMenu];
    // [self updatePlaces];

    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(54.755106, 35.620437), MKCoordinateSpanMake(0.014, 0.036));
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
}


- (void)updatePlaces
{
    _places = [[NLStorage sharedInstance] places];
    // [self redraw];
}

#pragma mark - Map-like stuff

- (void)clearMap
{
//    for (UIView *v in self.mapImageView.subviews) {
//        [v removeFromSuperview];
//    }
}

- (void)redraw
{
    [self clearMap];

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
    placeButton.tag = [place.id integerValue];
    [placeButton addTarget:self action:@selector(showPlaceMenu:) forControlEvents:UIControlEventTouchUpInside];
    // [self.resizableView addSubview:placeButton];
}


- (void)showPlaceMenu:(UIButton *)sender
{
    NLPlace *place = _.array(_places).find(^(NLPlace *p) {
        return (BOOL)(p.id.integerValue == sender.tag);
    });

    if (place == nil) {
        return;
    }

    NSLog(@"PLACE: %@", place.title);

    if (self.placeDetailsMenu.hidden == NO) {
        self.placeDetailsMenu.hidden = YES;
        self.placeDetailsMenu.alpha = 0;
    }

    [self showLocation:place.location];

    self.placeName.text = place.title;
    if (_currentLocation) {
        self.distanceToPlace.text = [NSString stringWithFormat:@"%.2f км.", [place distanceFromLocation:_currentLocation] / 100];
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.placeDetailsMenu.hidden = NO;
        self.placeDetailsMenu.alpha = 1.0;
    }];
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



- (void)hideDetailsMenu
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



#pragma mark - Scrolling delegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideDetailsMenu];
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [self hideDetailsMenu];
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
    [self.mapView setRegion:region animated:TRUE];
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


@end
