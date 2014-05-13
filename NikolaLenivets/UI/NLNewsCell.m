//
//  NLNewsCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsCell.h"
#import <AsyncImageView.h>

@implementation NLNewsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.counterLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.dateLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.titleLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:16];
}


- (void)populateFromNewsEntry:(NLNewsEntry *)entry
{
    self.titleLabel.text = entry.title;
    self.previewLabel.attributedString = [self attributedStringForString:entry.content];
    self.thumbnail.imageURL = [NSURL URLWithString:entry.thumbnail];
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
