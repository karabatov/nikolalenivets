//
//  NLPlace.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlace.h"
#import "NLCategory.h"

#import <DCKeyValueObjectMapping.h>
#import <DCArrayMapping.h>
#import <DCParserConfiguration.h>

@implementation NLPlace


+ (id)modelFromDictionary:(NSDictionary *)dict
{
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[NLCategory class] forAttribute:@"categories" onClass:[NLPlace class]];

    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:config];
    return [parser parseDictionary:dict];
}


- (CLLocationDistance)distanceFromLocation:(CLLocation *)loc
{
    return [[self location] distanceFromLocation:loc];
}


- (CLLocation *)location
{
    NSArray *locationComponents = [self.geo componentsSeparatedByString:@","];
    if (locationComponents.count < 2) {
        return nil;
    }

    CLLocationDegrees lat = [locationComponents.firstObject doubleValue];
    CLLocationDegrees lon = [locationComponents.lastObject doubleValue];

    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return placeLocation;
}


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_categories forKey:@"categories"];
    [coder encodeObject:_thumbnail forKey:@"thumbnail"];
    [coder encodeObject:_geo forKey:@"geo"];
    [coder encodeObject:_foursquare forKey:@"foursquare"];
    [coder encodeObject:_instagram forKey:@"instagram"];
    [coder encodeObject:_images forKey:@"images"];
    [coder encodeInteger:_itemStatus forKey:@"itemstatus"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _categories = [coder decodeObjectOfClass:[NSArray class] forKey:@"categories"];
        _thumbnail = [coder decodeObjectOfClass:[NSString class] forKey:@"thumbnail"];
        _geo = [coder decodeObjectOfClass:[NSString class] forKey:@"geo"];
        _foursquare = [coder decodeObjectOfClass:[NSString class] forKey:@"foursquare"];
        _instagram = [coder decodeObjectOfClass:[NSString class] forKey:@"instagram"];
        _images = [coder decodeObjectOfClass:[NSString class] forKey:@"images"];
        _itemStatus = [coder decodeIntegerForKey:@"itemstatus"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}


@end
