//
//  NLLocationManager.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLLocationManager.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

static NLLocationManager *_sharedInstance;

@implementation NLLocationManager
{
    CLLocationManager *_locationManager;
    CLHeading *_lastHeading;
    CLLocationCoordinate2D _nikolaCoordinate;
    double _angle;
}


+ (NLLocationManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NLLocationManager new];
    });
    return _sharedInstance;
}


- (instancetype)init
{
    if ((self = [super init])) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
        [_locationManager startUpdatingHeading];

        _nikolaCoordinate = CLLocationCoordinate2DMake(54.7516615, 35.5998094);
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    if (loc != nil) {
        _angle = [self userAngleToNikola:loc.coordinate];
        [[NSNotificationCenter defaultCenter] postNotificationName:NLUserLocationUpdated object:loc userInfo:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    _lastHeading = newHeading;
    [[NSNotificationCenter defaultCenter] postNotificationName:NLUserHeadingUpdated object:newHeading userInfo:nil];
}


- (CGAffineTransform)compassTransform
{
    return CGAffineTransformMakeRotation((_angle - _lastHeading.trueHeading) * M_PI / 180);
}


- (CATransform3D)compassTransform3D
{
    return CATransform3DMakeRotation((_angle - _lastHeading.trueHeading) * M_PI / 180, 0, 0, 1);
}


- (double)userAngleToNikola:(CLLocationCoordinate2D)current
{
    double x = 0.0,
           y = 0.0,
           degrees = 0.0,
           longitudeDelta = 0.0;

    longitudeDelta = _nikolaCoordinate.longitude - current.longitude;

    y = sin(longitudeDelta) * cos(_nikolaCoordinate.latitude);
    x = cos(current.latitude) * sin(_nikolaCoordinate.latitude) - sin(current.latitude) * cos(_nikolaCoordinate.latitude) * cos(longitudeDelta);
    degrees = RADIANS_TO_DEGREES(atan2(y, x));

    if(degrees < 0) {
        degrees = -degrees;
    } else {
        degrees = 360 - degrees;
    }
    return degrees;
}


@end
