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

#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_id forKey:@"id"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _id = [coder decodeObjectOfClass:[NSNumber class] forKey:@"id"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
