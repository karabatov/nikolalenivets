//
//  UIApplication+NLDirections.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 30.11.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "UIApplication+NLDirections.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>

@implementation UIApplication (NLDirections)

- (void)openDirectionsWithCoordinate:(CLLocationCoordinate2D)endingCoord
{
    NSDictionary *addressDict = @{ (NSString *)kABPersonAddressCityKey: NSLocalizedString(@"Никола-Ленивец", @"Address - Nikola-Lenivets"), (NSString *)kABPersonAddressStateKey: NSLocalizedString(@"Калужская область", @"Address - Kaluzhskaya oblast"), (NSString *)kABPersonAddressCountryKey: NSLocalizedString(@"Россия", @"Address - Russia"), (NSString *)kABPersonAddressCountryCodeKey: @"RU" };
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:addressDict];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];

    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

@end
