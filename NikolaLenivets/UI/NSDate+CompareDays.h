//
//  NSDate+CompareDays.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Helper methods on NSDate, mostly to compare if events are on the same day.
 */
@interface NSDate (CompareDays)

/**
 Check if date is on the same day as another date.
 
 @param date1 First date.
 @param date2 second date.
 @return YES if dates are on the same day, NO otherwise.
 */
+ (BOOL)isSameDayWithDate1:(NSDate *)date1 date2:(NSDate *)date2;

/**
 Check if date is on the same month as another date.

 @param date1 First date.
 @param date2 second date.
 @return YES if dates are on the same month, NO otherwise.
 */
+ (BOOL)isSameMonthWithDate1:(NSDate *)date1 date2:(NSDate *)date2;

/**
 Get number of days between two dates.
 
 @param date1 First date.
 @param date2 Second date.
 @return Number of days between dates.
 */
+ (NSInteger)daysBetween:(NSDate *)date1 andDate:(NSDate *)date2;

@end
