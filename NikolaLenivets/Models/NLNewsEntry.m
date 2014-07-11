//
//  NLNewsEntry.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsEntry.h"
#import <NSDate+Helper.h>

@implementation NLNewsEntry


- (NSDate *)pubDate
{
    NSDate *date = [NSDate dateFromString:self.pubdate withFormat:[NSDate timestampFormatString]];
    return date;
}


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_pubdate forKey:@"pubdate"];
    [coder encodeObject:_images forKey:@"images"];
    [coder encodeObject:_thumbnail forKey:@"thumbnail"];
    [coder encodeInteger:_itemStatus forKey:@"itemstatus"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _content = [coder decodeObjectOfClass:[NSString class] forKey:@"content"];
        _pubdate = [coder decodeObjectOfClass:[NSString class] forKey:@"pubdate"];
        _images = [coder decodeObjectOfClass:[NSArray class] forKey:@"images"];
        _thumbnail = [coder decodeObjectOfClass:[NSString class] forKey:@"thumbnail"];
        _itemStatus = [coder decodeIntegerForKey:@"itemstatus"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
