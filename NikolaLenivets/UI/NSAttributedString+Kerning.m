//
//  NSAttributedString+Kerning.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 09.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NSAttributedString+Kerning.h"
#import "NSString+StripHTMLTags.h"
#import "NSString+SoftHyphenation.h"

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
    return [NSAttributedString kernedStringForString:string withFontName:NLMonospacedBoldFont fontSize:fontSize kerning:kerning andColor:color];
}

+ (NSAttributedString *)kernedStringForString:(NSString *)string withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize kerning:(CGFloat)kerning andColor:(UIColor *)color
{
    NSMutableAttributedString *attributedString;

    attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    if ([attributedString length] >= 1) {
        [attributedString addAttribute:NSKernAttributeName
                                 value:[NSNumber numberWithFloat:kerning]
                                 range:NSMakeRange(0, [attributedString length])];

        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:fontName size:fontSize]
                                 range:NSMakeRange(0, [attributedString length])];

        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:color
                                 range:NSMakeRange(0, [attributedString length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.hyphenationFactor = 1.f;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [attributedString length])];
    }

    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

+ (NSAttributedString *)attributedStringForTitle:(NSString *)titleString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 1.f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.maximumLineHeight = 20.f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:24],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  // TODO: Make text tighter somehow.
                                  NSKernAttributeName: [NSNumber numberWithFloat:0.f],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[titleString softHyphenatedString] attributes:attributes];
    return title;
}

+ (NSAttributedString *)attributedStringForDateMonth:(NSString *)monthString
{
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:1.1f] };
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:monthString attributes:attributes];
    return title;
}


+ (NSAttributedString *)attributedStringForPlaceName:(NSString *)titleString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 1.f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.maximumLineHeight = 12.f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:12.5],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:0.5f],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[titleString softHyphenatedString] attributes:attributes];
    return title;
}


+ (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    // NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    // NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding] };
    // NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:nil];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[[[htmlString stringByStrippingHTML] softHyphenatedString] changeAccentsLettersToSymbols]];
    CFStringTrimWhitespace((CFMutableStringRef)[attributed mutableString]);
    NSRange range = {0, attributed.length};
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 1.f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 3.5f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLSerifFont size:10],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:0.0f],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    [attributed setAttributes:attributes range:range];
    __block NSRange trimmedRange = {0, 0};
    [[attributed string] enumerateSubstringsInRange:range options:NSStringEnumerationBySentences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        NSUInteger last = substringRange.location + substringRange.length;
        trimmedRange = NSMakeRange(0, last);
        if (last > 50) {
            *stop = YES;
        }
    }];

    NSRange zero = {0, 0};
    if (!NSEqualRanges(trimmedRange, zero)) {
        NSMutableAttributedString *trimmed = [[attributed attributedSubstringFromRange:trimmedRange] mutableCopy];
        return trimmed;
    } else {
        return attributed;
    }
}

@end
