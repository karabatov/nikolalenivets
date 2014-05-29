//
//  NLNewsEntryViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLDetailsViewController.h"

#import <DTCoreText.h>
#import <NSDate+Helper.h>

typedef enum {
    ShowingNewsEntry,
    ShowingEvent,
    ShowingPlace
} Mode;

@implementation NLDetailsViewController
{
    __strong NLNewsEntry *_entry;
    __strong NLEvent *_event;
    __strong NLPlace *_place;
}


- (id)initWithEntry:(NLNewsEntry *)entry
{
    self = [super initWithNibName:@"NLDetailsViewController" bundle:nil];
    if (self) {
        _entry = entry;
    }
    return self;
}


- (id)initWithEvent:(NLEvent *)event
{
    self = [super initWithNibName:@"NLDetailsViewController" bundle:nil];
    if (self) {
        _event = event;
    }
    return self;
}


- (id)initWithPlace:(NLPlace *)place
{
    self = [super initWithNibName:@"NLDetailsViewController" bundle:nil];
    if (self) {
        _place = place;
    }
    return self;
}

- (Mode)mode
{
    if (_entry)
        return ShowingNewsEntry;
    if (_event)
        return ShowingEvent;
    if (_place)
        return ShowingPlace;
    return -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:18];

    NSString *title = nil;
    NSString *content = nil;
    NSString *date = nil;

    switch ([self mode]) {
        case ShowingNewsEntry: {
            title = _entry.title;
            content = _entry.content;
            date = [[_entry pubDate] stringWithFormat:[NSDate dateFormatString]];
            break;
        }
        case ShowingEvent: {
            title = _event.title;
            content = _event.content;
            date = [[_event startDate] stringWithFormat:[NSDate dateFormatString]];
            [self.backButton setTitle:@"< СОБЫТИЯ" forState:UIControlStateNormal];
            break;
        }
        case ShowingPlace: {
            title = _place.title;
            content = _place.content;
            [self.backButton setTitle:@"< МЕСТА" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }

    self.titleLabel.text = title;
    self.contentText.attributedString = [self attributedStringForString:content];
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width,
                                        [self heightForString:content] + 151);
    self.scrollView.contentSize = self.contentView.frame.size;

    NSString *firstLetter = [[self.contentText.attributedString string] substringToIndex:1];
    self.capitalLetter.text = firstLetter;

    self.countView.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.dateLabel.font = [UIFont fontWithName:@"MonoCondensedC" size:8];
    self.dateLabel.text = date;
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
