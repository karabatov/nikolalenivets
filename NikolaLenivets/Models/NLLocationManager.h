//
//  NLLocationManager.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#define NLUserLocationUpdated @"NLUserLocationUpdated"
#define NLUserHeadingUpdated @"NLUserHeadingUpdated"

@interface NLLocationManager : NSObject <CLLocationManagerDelegate>

+ (NLLocationManager *)sharedInstance;
- (CGAffineTransform)compassTransform;

@end
