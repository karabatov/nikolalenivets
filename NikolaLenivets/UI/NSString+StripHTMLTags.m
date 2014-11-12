//
//  NSString+StripHTMLTags.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 13.11.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NSString+StripHTMLTags.h"

@implementation NSString (StripHTMLTags)

- (NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)changeAccentsLettersToSymbols
{
    NSString *strToCorrect = [self copy];
    static NSString * const codeMap[][2] = {
        {@"&iexcl;",    @"¡"},  {@"&laquo;",    @"«"},  {@"&raquo;",    @"»"},  {@"&lsaquo;",   @"‹"},
        {@"&rsaquo;",   @"›"},  {@"&sbquo;",    @"‚"},  {@"&bdquo;",    @"„"},  {@"&ldquo;",    @"“"},
        {@"&rdquo;",    @"”"},  {@"&lsquo;",    @"‘"},  {@"&rsquo;",    @"’"},  {@"&cent;",     @"¢"},
        {@"&pound;",    @"£"},  {@"&yen;",      @"¥"},  {@"&euro;",     @"€"},  {@"&curren;",   @"¤"},
        {@"&fnof;",     @"ƒ"},  {@"&gt;",       @">"},  {@"&lt;",       @"<"},  {@"&divide;",   @"÷"},
        {@"&deg;",      @"°"},  {@"&not;",      @"¬"},  {@"&plusmn;",   @"±"},  {@"&micro;",    @"µ"},
        {@"&amp;",      @"&"},  {@"&reg;",      @"®"},  {@"&copy;",     @"©"},  {@"&trade;",    @"™"},
        {@"&bull;",     @"•"},  {@"&middot;",   @"·"},  {@"&sect;",     @"§"},  {@"&ndash;",    @"–"},
        {@"&mdash;",    @"—"},  {@"&dagger;",   @"†"},  {@"&Dagger;",   @"‡"},  {@"&loz;",      @"◊"},
        {@"&uarr;",     @"↑"},  {@"&darr;",     @"↓"},  {@"&larr;",     @"←"},  {@"&rarr;",     @"→"},
        {@"&harr;",     @"↔"},  {@"&iquest;",   @"¿"},  {@"&nbsp;",     @" "},  {@"&quot;",     @"\""}
    };
    int count = sizeof(codeMap)/sizeof(codeMap[0]);
    for( int i=0; i<count; ++i ) {
        strToCorrect = [ strToCorrect stringByReplacingOccurrencesOfString: codeMap[i][0]
                                                                withString: codeMap[i][1] ];
    }

    return strToCorrect;
}

@end
