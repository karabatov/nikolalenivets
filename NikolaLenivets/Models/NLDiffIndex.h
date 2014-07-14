//
//  NLDiffIndex.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLModel.h"

@interface NLDiffIndex : NLModel

@property (strong, nonatomic) NSArray *news;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *teasers;
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSArray *screens;
@property (strong, nonatomic) NSArray *galleries;

@end
