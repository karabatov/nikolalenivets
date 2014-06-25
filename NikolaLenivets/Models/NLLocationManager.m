//
//  NLLocationManager.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLLocationManager.h"

static NLLocationManager *_sharedInstance;

@implementation NLLocationManager
{
    CLLocationManager *_locationManager;
}


+ (NLLocationManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NLLocationManager new];
    });
    return _sharedInstance;
}


- (id)init
{
    if ((self = [super init])) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        [_locationManager startUpdatingHeading];
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    if (loc != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NLUserLocationUpdated object:loc userInfo:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NLUserHeadingUpdated object:newHeading userInfo:nil];
}

@end
