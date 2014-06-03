//
//  NLGallery.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLGallery.h"
#import <DCKeyValueObjectMapping.h>
#import <DCArrayMapping.h>
#import <DCParserConfiguration.h>

@implementation NLImage


@end


@implementation NLGallery

+ (id)modelFromDictionary:(NSDictionary *)dict
{
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[NLImage class] forAttribute:@"images" onClass:[NLGallery class]];

    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:config];
    return [parser parseDictionary:dict];
}


- (NLImage *)cover
{
    NLImage *cover = _.array(self.images).find(^(NLImage *i) { return i.iscover.boolValue; });
    if (cover == nil)
        return self.images.firstObject;

    return cover;
}

@end
