//
//  NLEvent.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"

@interface NLEvent : NLModel

@property (strong, nonatomic) NSString *startdate;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *place;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *foursquare;
@property (strong, nonatomic) NSString *instagram;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *groups;
@property (nonatomic) NLItemStatus itemStatus;

- (NSDate *)startDate;

@end
