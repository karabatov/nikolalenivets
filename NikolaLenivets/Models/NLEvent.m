//
//  NLEvent.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEvent.h"
#import "NLGroup.h"
#import <DCKeyValueObjectMapping.h>
#import <DCArrayMapping.h>
#import <DCParserConfiguration.h>

@implementation NLEvent

+ (id)modelFromDictionary:(NSDictionary *)dict
{
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[NLGroup class] forAttribute:@"groups" onClass:[NLEvent class]];

    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:config];
    return [parser parseDictionary:dict];
}

@end
