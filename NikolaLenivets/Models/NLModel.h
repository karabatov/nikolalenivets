//
//  NLModel.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCKeyValueObjectMapping.h"

@interface NLModel : NSObject

@property (strong, nonatomic) NSNumber *id;

+ (id)modelFromDictionary:(NSDictionary *)dict;

@end
