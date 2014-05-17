//
//  NLGroup.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"

@interface NLGroup : NLModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *ticketprice;
@property (strong, nonatomic) NSString *startdate;
@property (strong, nonatomic) NSString *enddate;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *poster;
@property (strong, nonatomic) NSNumber *order;


@end