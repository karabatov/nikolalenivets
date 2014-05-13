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

@end
