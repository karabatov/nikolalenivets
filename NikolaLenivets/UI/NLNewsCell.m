//
//  NLNewsCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsCell.h"
#import <NSDate+Helper.h>

@implementation NLNewsCell
{
    __strong NLNewsEntry *_entry;
    __strong NLEvent *_event;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:YES];
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];

        UIColor *textColor = [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.f];

        self.counterLabel = [[UILabel alloc] init];
        self.counterLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
        self.counterLabel.textColor = textColor;
        [self.counterLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
        self.dayLabel.textColor = textColor;
        [self.dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.monthLabel = [[UILabel alloc] init];
        [self.monthLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.previewLabel = [[UILabel alloc] init];
        self.previewLabel.numberOfLines = 0;
        self.previewLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.previewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.thumbnail = [[AsyncImageView alloc] init];
        [self.thumbnail setContentMode:UIViewContentModeScaleAspectFill];
        [self.thumbnail setClipsToBounds:YES];
        [self.thumbnail setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.unreadIndicator = [[UIImageView alloc] init];
        [self.unreadIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.unreadIndicator.opaque = NO;

        [self.contentView addSubview:self.counterLabel];
        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.previewLabel];
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.unreadIndicator];
        [self.contentView addSubview:self.dayLabel];

        NSDictionary *views = @{ @"cntr": self.counterLabel,
                                 @"day": self.dayLabel,
                                 @"month": self.monthLabel,
                                 @"title": self.titleLabel,
                                 @"pre": self.previewLabel,
                                 @"thumb": self.thumbnail,
                                 @"unread": self.unreadIndicator };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[thumb(125.5)]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[unread(7)]-4.5-[cntr]-(>=0)-[day]-6-[month]-14.5-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[title]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[pre]-13-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[thumb]" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[unread(7)]-15.5-[title]-12-[pre]-17-|" options:kNilOptions metrics:nil views:views]];
        self.thumbnailHeight = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:0.f];
        [self.contentView addConstraint:self.thumbnailHeight];
        self.thumbnailBottomMargin = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeTop multiplier:1.f constant:-16.5f];
        [self.contentView addConstraint:self.thumbnailBottomMargin];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.counterLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
    }
    return self;
}


- (void)setUnreadStatus:(NLItemStatus)status
{
    switch (status) {
        case NLItemStatusNew:
            [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-red.png"]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusUnread:
            [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-gray.png"]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusRead:
            [self.unreadIndicator setImage:nil];
            [self.unreadIndicator setHidden:YES];
            break;

        default:
            break;
    }
}


- (void)populateFromNewsEntry:(NLNewsEntry *)entry
{
    _entry = entry;
    self.titleLabel.attributedText = [self attributedStringForTitle:_entry.title];
    self.previewLabel.attributedText = [self attributedStringForString:_entry.content];
    if ([_entry.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 125.5f;
        self.thumbnailBottomMargin.constant = -16.5f;
        self.thumbnail.imageURL = [NSURL URLWithString:_entry.thumbnail];
    }
    self.monthLabel.attributedText = [self attributedStringForDateMonth:[[[_entry pubDate] stringWithFormat:DefaultMonthFormat] uppercaseString]];
    self.dayLabel.text = [[_entry pubDate] stringWithFormat:DefaultDayFormat];
    [self setUnreadStatus:entry.itemStatus];
}


- (void)populateFromEvent:(NLEvent *)event
{
    _event = event;
    self.titleLabel.attributedText = [self attributedStringForTitle:_event.title];
    if ([_event.summary isEqualToString:@""]) {
        self.previewLabel.attributedText = [self attributedStringForString:_event.content];
    } else {
        self.previewLabel.attributedText = [self attributedStringForString:_event.summary];
    }
    if ([_event.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 125.5f;
        self.thumbnailBottomMargin.constant = 16.5f;
        self.thumbnail.imageURL = [NSURL URLWithString:_event.thumbnail];
    }
    self.monthLabel.text = [[[_event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
    [self setUnreadStatus:event.itemStatus];
}


+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry
{
    static NLNewsCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[NLNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NLNewsCell reuseIdentifier]];
    });

    [cell populateFromNewsEntry:entry];

    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}


+ (CGFloat)heightForCellWithEvent:(NLEvent *)event
{
    static NLNewsCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[NLNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NLNewsCell reuseIdentifier]];
    });

    [cell populateFromEvent:event];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}


- (NSAttributedString *)attributedStringForTitle:(NSString *)titleString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.maximumLineHeight = 20.f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:24],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  // TODO: Make text tighter somehow.
                                  NSKernAttributeName: [NSNumber numberWithFloat:0.f],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:titleString attributes:attributes];
    return title;
}


- (NSAttributedString *)attributedStringForDateMonth:(NSString *)monthString
{
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:1.1f] };
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:monthString attributes:attributes];
    return title;
}


- (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding] };
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:nil];
    CFStringTrimWhitespace((CFMutableStringRef)[attributed mutableString]);
    NSRange range = {0, attributed.length};
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.8f;
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

+ (NSString *)reuseIdentifier
{
    return @"newscell";
}

@end
