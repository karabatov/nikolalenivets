//
//  NSAttributedString+Kerning.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 09.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;

// TODO: Make the category more generic: accept font name, kerning value, etc.

/**
 Category to apply font kerning (tracking in Apple terms) to input strings.
 */
@interface NSAttributedString (Kerning)

/**
 Make a kerned string for input string.
 
 @param string Input string.
 @return Kerned NSAttributedString.
 */
+ (NSAttributedString *)kernedStringForString:(NSString *)string;

/**
 Make a kerned string for input string with selected font size and color.

 @param string Input string.
 @param fontSize Font size.
 @param color Desired color.
 @return Kerned NSAttributedString.
 */
+ (NSAttributedString *)kernedStringForString:(NSString *)string withFontSize:(CGFloat)fontSize andColor:(UIColor *)color;

@end
