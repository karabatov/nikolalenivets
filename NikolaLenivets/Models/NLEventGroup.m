//
//  NLGroup.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEventGroup.h"
#import "NLEvent.h"

#import <DCKeyValueObjectMapping.h>
#import <DCArrayMapping.h>
#import <DCParserConfiguration.h>

@implementation NLEventGroup

+ (id)modelFromDictionary:(NSDictionary *)dict
{
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[NLEvent class] forAttribute:@"events" onClass:[NLEventGroup class]];

    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:config];
    return [parser parseDictionary:dict];
}

@end
