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


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_ticketprice forKey:@"ticketprice"];
    [coder encodeObject:_startdate forKey:@"startdate"];
    [coder encodeObject:_enddate forKey:@"enddate"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_poster forKey:@"poster"];
    [coder encodeObject:_order forKey:@"order"];
    [coder encodeObject:_events forKey:@"events"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _ticketprice = [coder decodeObjectOfClass:[NSString class] forKey:@"ticketprice"];
        _startdate = [coder decodeObjectOfClass:[NSString class] forKey:@"startdate"];
        _enddate = [coder decodeObjectOfClass:[NSString class] forKey:@"enddate"];
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _poster = [coder decodeObjectOfClass:[NSString class] forKey:@"poster"];
        _order = [coder decodeObjectOfClass:[NSNumber class] forKey:@"order"];
        _events = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"events"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
