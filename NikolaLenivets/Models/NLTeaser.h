//
//  NLTeaser.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"

@interface NLTeaser : NLModel

@property (strong, nonatomic) NSNumber *order;
@property (strong, nonatomic) NSString *pubdate;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *news;
@property (strong, nonatomic) NSNumber *event;
@property (strong, nonatomic) NSNumber *place;

@end
