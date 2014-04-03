//
//  NLModel.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"

@implementation NLModel

+ (id)modelFromDictionary:(NSDictionary *)dict
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class]];
    return [parser parseDictionary:dict];
}

@end
