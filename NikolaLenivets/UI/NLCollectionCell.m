//
//  NLCollectionCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLCollectionCell.h"
#import <AsyncImageView.h>
#import <NSDate+Helper.h>

@implementation NLCollectionCell
{
    __strong NLNewsEntry *_entry;
    __strong NLEvent *_event;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.counterLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.dateLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:13];
    self.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:22];

    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.counterLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.previewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.thumbnail setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.unreadIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.previewLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.previewLabel.layoutFrameHeightIsConstrainedByBounds = NO;
    [self.contentView sendSubviewToBack:self.previewLabel];
    [self setClipsToBounds:YES];
}


- (void)setUnreadStatus:(NLItemStatus)status
{
    switch (status) {
        case NLItemStatusNew:
            [self.unreadIndicator setTextColor:[UIColor colorWithRed:255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusUnread:
            [self.unreadIndicator setTextColor:[UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0f]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusRead:
            [self.unreadIndicator setTextColor:[UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0f]];
            [self.unreadIndicator setHidden:YES];
            break;

        default:
            break;
    }
}


- (void)populateFromNewsEntry:(NLNewsEntry *)entry
{
    _entry = entry;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_entry.title attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
    self.titleLabel.attributedText = attributedTitle;
    self.previewLabel.attributedString = [self attributedStringForString:_entry.content];
    if ([_entry.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 123.0f;
        self.thumbnailBottomMargin.constant = 8.0f;
        self.thumbnail.imageURL = [NSURL URLWithString:_entry.thumbnail];
    }
    self.dateLabel.text = [[[_entry pubDate] stringWithFormat:DefaultDateFormat] uppercaseString];
    [self setUnreadStatus:entry.itemStatus];
}


- (void)populateFromEvent:(NLEvent *)event
{
    _event = event;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_event.title attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
    self.titleLabel.attributedText = attributedTitle;
    if ([_event.summary isEqualToString:@""]) {
        self.previewLabel.attributedString = [self attributedStringForString:_event.content];
    } else {
        self.previewLabel.attributedString = [self attributedStringForString:_event.summary];
    }
    if ([_event.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 123.0f;
        self.thumbnailBottomMargin.constant = 8.0f;
        self.thumbnail.imageURL = [NSURL URLWithString:_event.thumbnail];
    }
    self.dateLabel.text = [[[_event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
    [self setUnreadStatus:event.itemStatus];
}


+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry
{
    static NLCollectionCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLCollectionCellView" owner:self options:nil] firstObject];
    });

    [cell populateFromNewsEntry:entry];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}


+ (CGFloat)heightForCellWithEvent:(NLEvent *)event
{
    static NLCollectionCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLCollectionCellView" owner:self options:nil] firstObject];
    });

    [cell populateFromEvent:event];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    NSLog(@"suggested cell height: %g", height);

    return height;
}


- (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithHTMLData:htmlData
                                                                             documentAttributes:nil];
    CFStringTrimWhitespace((CFMutableStringRef)[attributed mutableString]);
    NSRange range = {0, attributed.length};
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:NLSerifFont size:12] range:range];
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
        NSAttributedString *trimmed = [attributed attributedSubstringFromRange:trimmedRange];
        return trimmed;
    } else {
        return attributed;
    }
}

@end
