//
//  NSAttributedString+Kerning.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 09.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NSAttributedString+Kerning.h"

@implementation NSAttributedString (Kerning)

+ (NSAttributedString *)kernedStringForString:(NSString *)string
{
    NSMutableAttributedString *attributedString;

    attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    [attributedString addAttribute:NSKernAttributeName
                             value:[NSNumber numberWithFloat:2.0]
                             range:NSMakeRange(0, [string length])];

    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:NLMonospacedBoldFont size:18]
                             range:NSMakeRange(0, [string length])];

    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]
                             range:NSMakeRange(0, [string length])];

    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

@end
