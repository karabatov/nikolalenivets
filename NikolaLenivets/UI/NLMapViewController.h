//
//  NLMapViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
@import MapKit;
#import "NLPlaceAnnotation.h"

@interface NLMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) IBOutlet UIView *placeDetailsMenu;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *distanceToPlace;
@property (weak, nonatomic) IBOutlet UILabel *distanceToPlaceLegend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToPlaceHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *placeUnreadIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeInfoIconsHeight;
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBarHeight;
@property (weak, nonatomic) IBOutlet UIView *backPlaceView;
@property (weak, nonatomic) IBOutlet UILabel *backPlaceTitle;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;


- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)showMyLocation:(id)sender;
- (instancetype)initWithPlace:(NLPlace *)place;
- (void)filterWantsToDismissWithReload:(BOOL)reload;

@end
