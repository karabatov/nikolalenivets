//
//  NSString+Distance.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 16.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;

/**
 Category to turn location data into human-readable form of appropriate magnitude.
 */
@interface NSString (Distance)


/**
 @brief Turn location into distance.
 @discussion Only supports Russian.
 
 @param distance Input distance.
 @return String representation of distance.
 */
+ (NSString *)stringFromDistance:(CLLocationDistance)distance;


@end
