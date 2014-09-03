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
    return [NSAttributedString kernedStringForString:string withFontSize:18 andColor:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]];
}

+ (NSAttributedString *)kernedStringForString:(NSString *)string withFontSize:(CGFloat)fontSize andColor:(UIColor *)color
{
    return [NSAttributedString kernedStringForString:string withFontSize:fontSize kerning:2.0 andColor:color];
}

+ (NSAttributedString *)kernedStringForString:(NSString *)string withFontSize:(CGFloat)fontSize kerning:(CGFloat)kerning andColor:(UIColor *)color
{
    NSMutableAttributedString *attributedString;

    attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    if ([attributedString length] > 1) {
        [attributedString addAttribute:NSKernAttributeName
                                 value:[NSNumber numberWithFloat:kerning]
                                 range:NSMakeRange(0, [attributedString length])];

        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:NLMonospacedBoldFont size:fontSize]
                                 range:NSMakeRange(0, [attributedString length])];

        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:color
                                 range:NSMakeRange(0, [attributedString length])];
    }

    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

@end
