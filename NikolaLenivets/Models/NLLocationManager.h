//
//  NLLocationManager.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define NLUserLocationUpdated @"NLUserLocationUpdated"

@interface NLLocationManager : NSObject <CLLocationManagerDelegate>

+ (NLLocationManager *)sharedInstance;

@end
