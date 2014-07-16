//
//  NSString+Distance.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 16.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NSString+Distance.h"

@implementation NSString (Distance)


+ (NSString *)stringFromDistance:(CLLocationDistance)distance
{
    if (distance > 999) {
        return [NSString stringWithFormat:@"%0.2f км", distance / 1000];
    } else {
        return [NSString stringWithFormat:@"%0.0f м", distance];
    }
}


@end
