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
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.counterLabel = [[UILabel alloc] init];
        [self.counterLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

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
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.previewLabel];
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.unreadIndicator];

        // TODO: Check if this is still necessary.
        // self.previewLabel.lineBreakMode = NSLineBreakByWordWrapping;
        // self.previewLabel.layoutFrameHeightIsConstrainedByBounds = NO;
        // [self.contentView sendSubviewToBack:self.previewLabel];
        [self setClipsToBounds:YES];

        NSDictionary *views = @{ @"cntr": self.counterLabel, @"date": self.dateLabel, @"title": self.titleLabel, @"pre": self.previewLabel, @"thumb": self.thumbnail, @"unread": self.unreadIndicator };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[thumb(125.5)]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5.5-[unread(6)]-5.5-[cntr]-(>=0)-[date]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[title]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[pre]-13-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[thumb]" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[unread(6)]-18-[title]-16-[pre]-17-|" options:kNilOptions metrics:nil views:views]];
        self.thumbnailHeight = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:0.f];
        [self.contentView addConstraint:self.thumbnailHeight];
        self.thumbnailBottomMargin = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeTop multiplier:1.f constant:-17.f];
        [self.contentView addConstraint:self.thumbnailBottomMargin];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.counterLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
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
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:_entry.title attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
    self.titleLabel.attributedText = attributedTitle;
    self.previewLabel.attributedText = [self attributedStringForString:_entry.content];
    if ([_entry.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 125.5f;
        self.thumbnailBottomMargin.constant = -17.0f;
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
        self.thumbnailBottomMargin.constant = 17.0f;
        self.thumbnail.imageURL = [NSURL URLWithString:_event.thumbnail];
    }
    self.dateLabel.text = [[[_event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
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


- (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    // NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithHTMLData:htmlData documentAttributes:nil];
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding] };
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:nil];
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
