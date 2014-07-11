//
//  NLTeaser.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTeaser.h"

@implementation NLTeaser

#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_order forKey:@"order"];
    [coder encodeObject:_pubdate forKey:@"pubdate"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_news forKey:@"news"];
    [coder encodeObject:_event forKey:@"event"];
    [coder encodeObject:_place forKey:@"place"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _order = [coder decodeObjectOfClass:[NSNumber class] forKey:@"order"];
        _pubdate = [coder decodeObjectOfClass:[NSString class] forKey:@"pubdate"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _news = [coder decodeObjectOfClass:[NSNumber class] forKey:@"news"];
        _event = [coder decodeObjectOfClass:[NSNumber class] forKey:@"event"];
        _place = [coder decodeObjectOfClass:[NSNumber class] forKey:@"place"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
