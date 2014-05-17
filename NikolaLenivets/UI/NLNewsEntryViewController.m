//
//  NLNewsEntryViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsEntryViewController.h"
#import <DTCoreText.h>
#import <NSDate+Helper.h>

@implementation NLNewsEntryViewController
{
    __strong NLNewsEntry *_entry;
}


- (id)initWithEntry:(NLNewsEntry *)entry
{
    self = [super initWithNibName:@"NLNewsEntryViewController" bundle:nil];
    if (self) {
        _entry = entry;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:18];
    self.titleLabel.text = _entry.title;
    self.contentText.attributedString = [self attributedStringForString:_entry.content];
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width,
                                        [self heightForString:_entry.content] + 151);
    self.scrollView.contentSize = self.contentView.frame.size;

    NSString *firstLetter = [[self.contentText.attributedString string] substringToIndex:1];
    self.capitalLetter.text = firstLetter;

    self.countView.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.dateLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.dateLabel.text = [[_entry pubDate] stringWithFormat:[NSDate dateFormatString]];
}


- (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithHTMLData:htmlData
                                                                                        options:@{DTUseiOS6Attributes: @(YES)}
                                                                             documentAttributes:nil];
    NSRange range = {0, attributed.length};
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"BookmanC" size:14] range:range];    
    return attributed;
}


- (CGFloat)heightForString:(NSString *)string
{
    NSAttributedString *htmlString = [self attributedStringForString:string];
    
    CGRect rect = [htmlString boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           context:nil];
    
    CGFloat height = rect.size.height;
    return height + 20;
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
