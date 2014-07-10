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


- (void)populateFromNewsEntry:(NLNewsEntry *)entry
{
    _entry = entry;
    self.titleLabel.text = _entry.title;
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
}


- (void)populateFromEvent:(NLEvent *)event
{
    _event = event;
    self.titleLabel.text = _event.title;
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
