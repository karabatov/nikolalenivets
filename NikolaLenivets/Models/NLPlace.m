//
//  NLPlace.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlace.h"

@implementation NLPlace

- (CLLocationDistance)distanceFromLocation:(CLLocation *)loc
{
    return [[self location] distanceFromLocation:loc];
}


- (CLLocation *)location
{
    NSArray *locationComponents = [self.geo componentsSeparatedByString:@","];
    if (locationComponents.count < 2) {
        return nil;
    }

    CLLocationDegrees lat = [locationComponents.firstObject doubleValue];
    CLLocationDegrees lon = [locationComponents.lastObject doubleValue];

    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return placeLocation;
}

@end
