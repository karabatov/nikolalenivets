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
    self.counterLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.dateLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.titleLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:16];
}


- (void)populateFromNewsEntry:(NLNewsEntry *)entry
{
    _entry = entry;
    self.titleLabel.text = _entry.title;
    self.previewLabel.attributedString = [self attributedStringForString:_entry.content];
    if (_entry.thumbnail == nil) {
        self.thumbnail.image = nil;
    }
    self.thumbnail.imageURL = [NSURL URLWithString:_entry.thumbnail];
    self.dateLabel.text = [[_entry pubDate] stringWithFormat:[NSDate dateFormatString]];
}


- (void)populateFromEvent:(NLEvent *)event
{
    _event = event;
    self.titleLabel.text = _event.title;
    self.previewLabel.attributedString = [self attributedStringForString:_event.content];
    if (_event.thumbnail == nil) {
        self.thumbnail.image = nil;
    }
    self.thumbnail.imageURL = [NSURL URLWithString:_event.thumbnail];
    self.dateLabel.text = [[_event startDate] stringWithFormat:[NSDate dateFormatString]];
}


+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry
{
    if (entry.thumbnail != nil) {
        return 314.0;
    }
    return 89.0;
}


+ (CGFloat)heightForCellWithEvent:(NLEvent *)event
{
    return [self heightForCellWithEntry:(NLNewsEntry *)event];
}


- (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithHTMLData:htmlData
                                                                             documentAttributes:nil];
    NSRange range = {0, attributed.length};
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"BookmanC" size:11] range:range];
    
    return attributed;
}

@end
