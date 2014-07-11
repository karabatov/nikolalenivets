//
//  NLNewsCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsCell.h"
#import <AsyncImageView.h>
#import <NSDate+Helper.h>

@implementation NLNewsCell
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
    self.previewLabel.attributedString = [self attributedStringForString:_event.content];
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
}


+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry
{
    static NLNewsCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLNewsCellView" owner:self options:nil] firstObject];
    });

    [cell populateFromNewsEntry:entry];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}


+ (CGFloat)heightForCellWithEvent:(NLEvent *)event
{
    static NLNewsCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLNewsCellView" owner:self options:nil] firstObject];
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
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithHTMLData:htmlData
                                                                             documentAttributes:nil];
    NSRange range = {0, attributed.length};
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:NLSerifFont size:12] range:range];
    
    return attributed;
}

@end
