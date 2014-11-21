//
//  NLSearchTextView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 12.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchTextView.h"

#define kFontSize 37.f

@implementation NLSearchTextView

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.origin.x -= 0.5;
    originalRect.origin.y += 11.f;
    originalRect.size.width = 3.f;
    originalRect.size.height = 23.5f;
    return originalRect;
}

- (void)layoutSubviews
{
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:[self searchAttributesForFontWithName:NLMonospacedBoldFont andSize:[self requiredFontSize]]];
    [super layoutSubviews];
}

- (CGFloat)requiredFontSize
{
    CGFloat originalFontSize = kFontSize;
    CGFloat fontSize = originalFontSize;

    BOOL found = NO;
    do {
        if ([self tryFontWithName:NLMonospacedBoldFont andSize:fontSize]) {
            found = YES;
            break;
        }

        fontSize -= 0.5;

        if (fontSize < 18) {
            break;
        }

    } while (YES);

    return fontSize;
}

- (BOOL)tryFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize
{
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:self.text attributes:[self searchAttributesForFontWithName:fontName andSize:fontSize]];
    CGRect bounds = [as boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize ceilBounds = CGSizeMake(ceilf(bounds.size.width), ceilf(bounds.size.height + 15.f));
    BOOL itWorks = [self doesThisSize:ceilBounds fitInThisSize:self.bounds.size];
    return itWorks;
}

- (BOOL)doesThisSize:(CGSize)aa fitInThisSize:(CGSize)bb
{
    if ( aa.width > bb.width ) return NO;
    if ( aa.height > bb.height ) return NO;
    return YES;
}

- (NSDictionary *)searchAttributesForFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 1.f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.maximumLineHeight = fontSize + 2.f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:fontName size:fontSize],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:4.3f * fontSize/kFontSize],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    return attributes;
}

@end
