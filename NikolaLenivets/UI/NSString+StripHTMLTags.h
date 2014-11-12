//
//  NSString+StripHTMLTags.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 13.11.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;

@interface NSString (StripHTMLTags)

/** Quick and dirty HTML tag stripper. */
- (NSString *)stringByStrippingHTML;

/** Very simple replacer. */
- (NSString *)changeAccentsLettersToSymbols;

@end
