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
#import "NSDate+CompareDays.h"
#import "NSAttributedString+Kerning.h"

@implementation NLCollectionCell
{
    __strong NLNewsEntry *_entry;
    __strong NLEvent *_event;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

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

        self.alarmIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"event-alarm.png"]];
        [self.alarmIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.alarmIcon.hidden = YES;

        [self.contentView addSubview:self.counterLabel];
        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.previewLabel];
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.unreadIndicator];
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.alarmIcon];

        NSDictionary *views = @{ @"cntr": self.counterLabel,
                                 @"day": self.dayLabel,
                                 @"month": self.monthLabel,
                                 @"title": self.titleLabel,
                                 @"pre": self.previewLabel,
                                 @"thumb": self.thumbnail,
                                 @"unread": self.unreadIndicator,
                                 @"alarm": self.alarmIcon };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[thumb(125.5)]-17.5-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[unread(7)]-4.5-[cntr]-(>=0)-[alarm(9)]-1.5-[day]-6-[month]" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[title]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[pre]-13-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[thumb]" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[unread(7)]-15.5-[title]-12-[pre]-16.5-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[alarm(12.5)]" options:kNilOptions metrics:nil views:views]];
        self.thumbnailHeight = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:0.f];
        [self.contentView addConstraint:self.thumbnailHeight];
        self.thumbnailBottomMargin = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeTop multiplier:1.f constant:-16.5f];
        [self.contentView addConstraint:self.thumbnailBottomMargin];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.counterLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.alarmIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];
        self.monthRightMargin = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.monthLabel attribute:NSLayoutAttributeRight multiplier:1.f constant:14.5f];
        [self.contentView addConstraint:self.monthRightMargin];

        UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self.layer setBorderColor:borderGray.CGColor];
        [self.layer setBorderWidth:0.5f];
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
    self.titleLabel.attributedText = [NSAttributedString attributedStringForTitle:_entry.title];
    self.previewLabel.attributedText = [NSAttributedString attributedStringForString:_entry.content];
    self.monthRightMargin.constant = 15.f;
    if ([_entry.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.5f;
    } else {
        self.thumbnailHeight.constant = 125.5f;
        self.thumbnailBottomMargin.constant = -16.5f;
        self.thumbnail.imageURL = [NSURL URLWithString:_entry.thumbnail];
    }
    self.monthLabel.attributedText = [NSAttributedString attributedStringForDateMonth:[[[_entry pubDate] stringWithFormat:DefaultMonthFormat] uppercaseString]];
    self.dayLabel.text = [[_entry pubDate] stringWithFormat:DefaultDayFormat];
    [self setUnreadStatus:entry.itemStatus];
}


- (void)populateFromEvent:(NLEvent *)event
{
    _event = event;
    self.titleLabel.attributedText = [NSAttributedString attributedStringForTitle:_event.title];
    self.monthRightMargin.constant = 17.5f;
    if ([_event.summary isEqualToString:@""]) {
        self.previewLabel.attributedText = [NSAttributedString attributedStringForString:_event.content];
    } else {
        self.previewLabel.attributedText = [NSAttributedString attributedStringForString:_event.summary];
    }
    self.thumbnail.image = nil;
    self.thumbnailHeight.constant = 0.0f;
    self.thumbnailBottomMargin.constant = 0.5f;
    self.dayLabel.text = @"";
    self.monthLabel.attributedText = [NSAttributedString kernedStringForString:[[_event startDate] stringWithFormat:DefaultTimeFormat] withFontSize:12.f kerning:1.1f andColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];
    if ([NSDate isSameDayWithDate1:[NSDate date] date2:[_event startDate]]) {
        [self.alarmIcon setHidden:NO];
    } else {
        [self.alarmIcon setHidden:YES];
    }
    [self setUnreadStatus:event.itemStatus];
}


+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry
{
    static NLCollectionCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[NLCollectionCell alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
        cell = [[NLCollectionCell alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });

    [cell populateFromEvent:event];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}


+ (NSString *)reuseIdentifier
{
    return @"collectioncell";
}

@end
