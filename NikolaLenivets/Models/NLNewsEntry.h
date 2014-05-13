//
//  NLNewsEntry.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLModel.h"

@interface NLNewsEntry : NLModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *pubdate;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *thumbnail;

@end
