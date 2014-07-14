//
//  NLScreen.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLScreen.h"

@implementation NLScreen


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_fullname forKey:@"fullname"];
    [coder encodeObject:_image forKey:@"image"];
    [coder encodeObject:_url forKey:@"url"];
    [coder encodeObject:_content forKey:@"content"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _fullname = [coder decodeObjectOfClass:[NSString class] forKey:@"fullname"];
        _image = [coder decodeObjectOfClass:[NSString class] forKey:@"image"];
        _url = [coder decodeObjectOfClass:[NSString class] forKey:@"url"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}


@end
