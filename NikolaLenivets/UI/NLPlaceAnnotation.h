//
//  NLPlaceAnnotation.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 20.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import MapKit;
#import "NLPlace.h"

@interface NLPlaceAnnotation : MKPointAnnotation

@property (strong, nonatomic) NLPlace *place;

- (instancetype)initWithPlace:(NLPlace *)place;

@end
