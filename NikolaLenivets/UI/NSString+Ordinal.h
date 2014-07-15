//
//  NSString+Ordinal.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;


/**
 Category to turn ordinal numbers into words.
 */
@interface NSString (Ordinal)


/**
 @brief Turn input number into ordinal string representation.
 @discussion Returns Russian string representation.
 
 @param ordinal Input number to turn into string.
 @return Ordinal number as string.
 */
+ (NSString *)ordinalRepresentationWithNumber:(NSInteger)ordinal;


@end
