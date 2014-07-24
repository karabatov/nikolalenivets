//
//  NLPlaceAnnotation.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 20.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlaceAnnotation.h"

@implementation NLPlaceAnnotation

- (instancetype)initWithPlace:(NLPlace *)place
{
    self = [super init];
    if (self) {
        self.place = place;
        self.coordinate = [place location].coordinate;
        self.title = place.title;
    }
    return self;
}

@end
