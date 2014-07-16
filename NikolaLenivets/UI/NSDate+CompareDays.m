//
//  NSDate+CompareDays.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NSDate+CompareDays.h"

@implementation NSDate (CompareDays)


+ (BOOL)isSameDayWithDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];

    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


+ (BOOL)isSameMonthWithDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];

    return [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}


+ (NSInteger)daysBetween:(NSDate *)date1 andDate:(NSDate *)date2
{
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger daysBetween = ABS([components day]);
    return daysBetween + 1;
}


@end
