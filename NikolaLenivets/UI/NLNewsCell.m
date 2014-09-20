//
//  NLNewsCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsCell.h"
#import <NSDate+Helper.h>
#import "UIImage+Grayscale.h"
#import "NSAttributedString+Kerning.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NLNewsCell
{
    __strong NLNewsEntry *_entry;
    __strong NLEvent *_event;
    __strong UIImage *_coloredImage;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125.5f, 125.5f)];
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
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[thumb]-(>=0)-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[unread(7)]-15.5-[title]-12-[pre]-17-|" options:kNilOptions metrics:nil views:views]];
        self.thumbnailHeight = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:0.f];
        [self.contentView addConstraint:self.thumbnailHeight];
        self.thumbnailBottomMargin = [NSLayoutConstraint constraintWithItem:self.thumbnail attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
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
    self.titleLabel.attributedText = [NSAttributedString attributedStringForTitle:_entry.title];
    self.previewLabel.attributedText = [NSAttributedString attributedStringForString:_entry.content];
    if ([_entry.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 125.5f;
        self.thumbnailBottomMargin.constant = -16.5f;
        [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:_entry.thumbnail]];
    }
    self.monthLabel.attributedText = [NSAttributedString attributedStringForDateMonth:[[[_entry pubDate] stringWithFormat:DefaultMonthFormat] uppercaseString]];
    self.dayLabel.text = [[_entry pubDate] stringWithFormat:DefaultDayFormat];
    [self setUnreadStatus:entry.itemStatus];
}


- (void)populateFromEvent:(NLEvent *)event
{
    _event = event;
    self.titleLabel.attributedText = [NSAttributedString attributedStringForTitle:_event.title];
    if ([_event.summary isEqualToString:@""]) {
        self.previewLabel.attributedText = [NSAttributedString attributedStringForString:_event.content];
    } else {
        self.previewLabel.attributedText = [NSAttributedString attributedStringForString:_event.summary];
    }
    if ([_event.thumbnail isEqualToString:@""]) {
        self.thumbnail.image = nil;
        self.thumbnailHeight.constant = 0.0f;
        self.thumbnailBottomMargin.constant = 0.0f;
    } else {
        self.thumbnailHeight.constant = 125.5f;
        self.thumbnailBottomMargin.constant = -16.5f;
        [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:_entry.thumbnail]];
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


- (void)makeImageGrayscale:(BOOL)shouldMakeImageGrayscale
{
    if (self.thumbnail.image && shouldMakeImageGrayscale) {
        _coloredImage = self.thumbnail.image;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            UIImage *grayscale = [_coloredImage convertImageToGrayscale];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25f animations:^{
                    [self.thumbnail setImage:grayscale];
                }];
            });
        });
    } else {
        if (_coloredImage) {
            [UIView animateWithDuration:0.25f animations:^{
                [self.thumbnail setImage:_coloredImage];
            }];
        }
    }
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    if (highlighted) {
        [self makeImageGrayscale:YES];
        [UIView animateWithDuration:0.25f animations:^{
            self.contentView.alpha = 0.5f;
        }];
    } else {
        [self makeImageGrayscale:NO];
        [UIView animateWithDuration:0.25f animations:^{
            self.contentView.alpha = 1.f;
        }];
    }
}


- (void)prepareForReuse
{
    _coloredImage = nil;
    self.thumbnail.image = nil;
    [self.thumbnail sd_cancelCurrentImageLoad];
}


+ (NSString *)reuseIdentifier
{
    return @"newscell";
}

@end
