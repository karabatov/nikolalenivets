//
//  NLPlace.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"

@interface NLPlace : NLModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *geo;
@property (strong, nonatomic) NSString *foursquare;
@property (strong, nonatomic) NSString *instagram;
@property (strong, nonatomic) NSString *images;
@property (nonatomic) NLItemStatus itemStatus;

- (CLLocation *)location;
- (CLLocationDistance)distanceFromLocation:(CLLocation *)loc;

@end
