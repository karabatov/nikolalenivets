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


@end
