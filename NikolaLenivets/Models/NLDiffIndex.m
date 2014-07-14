//
//  NLDiffIndex.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLDiffIndex.h"

#import <DCKeyValueObjectMapping.h>
#import <DCArrayMapping.h>
#import <DCParserConfiguration.h>

@implementation NLDiffIndex


+ (id)modelFromDictionary:(NSDictionary *)dict
{
    DCArrayMapping *newsMapper = [DCArrayMapping mapperForClassElements:[NLModel class] forAttribute:@"news" onClass:[NLDiffIndex class]];
    DCArrayMapping *eventsMapper = [DCArrayMapping mapperForClassElements:[NLModel class] forAttribute:@"events" onClass:[NLDiffIndex class]];
    DCArrayMapping *teasersMapper = [DCArrayMapping mapperForClassElements:[NLModel class] forAttribute:@"teasers" onClass:[NLDiffIndex class]];
    DCArrayMapping *placesMapper = [DCArrayMapping mapperForClassElements:[NLModel class] forAttribute:@"places" onClass:[NLDiffIndex class]];
    DCArrayMapping *screensMapper = [DCArrayMapping mapperForClassElements:[NLModel class] forAttribute:@"screens" onClass:[NLDiffIndex class]];
    DCArrayMapping *galleriesMapper = [DCArrayMapping mapperForClassElements:[NLModel class] forAttribute:@"galleries" onClass:[NLDiffIndex class]];

    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:newsMapper];
    [config addArrayMapper:eventsMapper];
    [config addArrayMapper:teasersMapper];
    [config addArrayMapper:placesMapper];
    [config addArrayMapper:screensMapper];
    [config addArrayMapper:galleriesMapper];

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:config];
    return [parser parseDictionary:dict];
}


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_news forKey:@"news"];
    [coder encodeObject:_events forKey:@"events"];
    [coder encodeObject:_teasers forKey:@"teasers"];
    [coder encodeObject:_places forKey:@"places"];
    [coder encodeObject:_screens forKey:@"screens"];
    [coder encodeObject:_galleries forKey:@"galleries"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _news = [coder decodeObjectOfClass:[NSArray class] forKey:@"news"];
        _events = [coder decodeObjectOfClass:[NSArray class] forKey:@"events"];
        _teasers = [coder decodeObjectOfClass:[NSArray class] forKey:@"teasers"];
        _places = [coder decodeObjectOfClass:[NSArray class] forKey:@"places"];
        _screens = [coder decodeObjectOfClass:[NSArray class] forKey:@"screens"];
        _galleries = [coder decodeObjectOfClass:[NSArray class] forKey:@"galleries"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
