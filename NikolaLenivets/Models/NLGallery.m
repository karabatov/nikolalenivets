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


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_image forKey:@"image"];
    [coder encodeObject:_iscover forKey:@"iscover"];
    [coder encodeObject:_order forKey:@"order"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _image = [coder decodeObjectOfClass:[NSString class] forKey:@"image"];
        _iscover = [coder decodeObjectOfClass:[NSNumber class] forKey:@"iscover"];
        _order = [coder decodeObjectOfClass:[NSNumber class] forKey:@"order"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}


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


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_shortcut forKey:@"shortcut"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_images forKey:@"images"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _shortcut = [coder decodeObjectOfClass:[NSString class] forKey:@"shortcut"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _images = [coder decodeObjectOfClass:[NSArray class] forKey:@"images"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
