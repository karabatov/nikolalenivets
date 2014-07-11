//
//  NLEvent.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEvent.h"
#import "NLEventGroup.h"
#import <NSDate+Helper.h>

@implementation NLEvent


- (NSDate *)startDate
{
    NSDate *date = [NSDate dateFromString:self.startdate withFormat:[NSDate timestampFormatString]];
    return date;
}


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_startdate forKey:@"startdate"];
    [coder encodeObject:_thumbnail forKey:@"thumbnail"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_categories forKey:@"categories"];
    [coder encodeObject:_summary forKey:@"summary"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_place forKey:@"place"];
    [coder encodeObject:_facebook forKey:@"facebook"];
    [coder encodeObject:_foursquare forKey:@"foursquare"];
    [coder encodeObject:_instagram forKey:@"instagram"];
    [coder encodeObject:_images forKey:@"images"];
    [coder encodeObject:_groups forKey:@"groups"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _startdate = [coder decodeObjectOfClass:[NSString class] forKey:@"startdate"];
        _thumbnail = [coder decodeObjectOfClass:[NSString class] forKey:@"thumbnail"];
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _categories = [coder decodeObjectOfClass:[NSArray class] forKey:@"categories"];
        _summary = [coder decodeObjectOfClass:[NSString class] forKey:@"summary"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _place = [coder decodeObjectOfClass:[NSNumber class] forKey:@"place"];
        _facebook = [coder decodeObjectOfClass:[NSString class] forKey:@"facebook"];
        _foursquare = [coder decodeObjectOfClass:[NSString class] forKey:@"foursquare"];
        _instagram = [coder decodeObjectOfClass:[NSString class] forKey:@"instagram"];
        _images = [coder decodeObjectOfClass:[NSArray class] forKey:@"images"];
        _groups = [coder decodeObjectOfClass:[NSArray class] forKey:@"groups"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
