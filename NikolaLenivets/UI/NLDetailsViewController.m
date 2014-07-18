//
//  NLNewsEntryViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLDetailsViewController.h"
#import "NLGallery.h"
#import "NLStorage.h"
#import "NLGalleryViewController.h"

#import <DTCoreText.h>
#import <NSDate+Helper.h>
#import "NSString+Distance.h"
#import "NSString+Ordinal.h"

typedef enum {
    ShowingNewsEntry,
    ShowingEvent,
    ShowingPlace
} Mode;

@implementation NLDetailsViewController
{
    CLLocation *_currentLocation;
    NLNewsEntry *_entry;
    NLEvent *_event;
    NLPlace *_place;
    NLGallery *_gallery;
    NLGalleryViewController *_galleryVC;
    NSArray *_textParts;
    NSInteger _eventGroupOrder;
}


- (id)initWithEntry:(NLNewsEntry *)entry
{
    self = [super initWithNibName:@"NLDetailsViewController" bundle:nil];
    if (self) {
        _entry = entry;
    }
    return self;
}


- (id)initWithEvent:(NLEvent *)event withOrderInGroup:(NSInteger)order;
{
    self = [super initWithNibName:@"NLDetailsViewController" bundle:nil];
    if (self) {
        _event = event;
        _eventGroupOrder = order;
    }
    return self;
}


- (id)initWithPlace:(NLPlace *)place currentLocation:(CLLocation *)currentLocation;
{
    self = [super initWithNibName:@"NLDetailsViewController" bundle:nil];
    if (self) {
        _place = place;
        _currentLocation = currentLocation;
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
    
    self.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:30];
    self.detailsViewTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.dateLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:13];
    self.countView.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.capitalLetter.font = [UIFont systemFontOfSize:250];
    [self.capitalLetter setHidden:YES];

    NSString *title = nil;
    NSString *content = nil;
    NSString *date = nil;
    NSInteger indexNumber = 0;

    switch ([self mode]) {
        case ShowingNewsEntry: {
            title = _entry.title;
            content = _entry.content;
            date = [[[_entry pubDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            indexNumber = [[[NLStorage sharedInstance] news] indexOfObject:_entry];
            [self setUnreadStatus:_entry.itemStatus];
            self.capitalLetter.textColor = [UIColor colorWithRed:247.0f/255.0f green:250.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
            for (UIView *view in [self.eventDayView subviews]) {
                [view removeFromSuperview];
            }
            break;
        }
        case ShowingEvent: {
            title = _event.title;
            content = _event.content;
            date = [[[_event startDate] stringWithFormat:DefaultTimeFormat] uppercaseString];
            self.detailsViewTitleLabel.text = @"СОБЫТИЯ";
            [self setUnreadStatus:_event.itemStatus];
            self.capitalLetter.textColor = [UIColor colorWithRed:135.0f/255.0f green:163.0f/255.0f blue:1.0f alpha:1.0f];
            self.eventDayHeight.constant = 26;
            self.eventDayView.dateLabel.text = [[[_event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            self.eventDayView.dayOrderLabel.text = [[NSString stringWithFormat:@"%@ %@", @"день", [NSString ordinalRepresentationWithNumber:_eventGroupOrder]] uppercaseString];
            UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
            [self.eventDayView.layer setBorderColor:borderGray.CGColor];
            [self.eventDayView.layer setBorderWidth:0.5f];
            indexNumber = -1;
            break;
        }
        case ShowingPlace: {
            title = _place.title;
            content = _place.content;
            if (_currentLocation) {
                CLLocationDistance distance = [_place distanceFromLocation:_currentLocation];
                self.countView.text = [[NSString stringFromDistance:distance] uppercaseString];
            } else {
                self.countView.text = @"∞ КМ";
            }
            self.detailsViewTitleLabel.text = @"МЕСТА";
            [self setUnreadStatus:_place.itemStatus];
            self.capitalLetter.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
            for (UIView *view in [self.eventDayView subviews]) {
                [view removeFromSuperview];
            }
            indexNumber = -1; //[[[NLStorage sharedInstance] places] indexOfObject:_place];
            break;
        }
        default:
            indexNumber = -1;
            break;
    }

    self.titleLabel.text = title;
    _gallery = [self galleryFromString:content];
    _textParts = [self textParts:content];

    if (indexNumber > -1) {
        self.countView.text = [NSString stringWithFormat:@"%02ld", (long)indexNumber + 1];
    } else {
        if ([self mode] == ShowingPlace) {
            if (_currentLocation) {
                self.countView.text = [[NSString stringFromDistance:[_place distanceFromLocation:_currentLocation]] uppercaseString];
            }
        } else {
            self.countView.text = @"";
        }

    }

    self.firstPartWebView.delegate = self;
    self.secondPartLabel.delegate = self;
    self.firstPartWebView.scrollView.bounces = NO;
    self.secondPartLabel.scrollView.bounces = NO;
    [self.firstPartWebView loadHTMLString:_textParts.firstObject baseURL:[NSURL URLWithString:@"http://"]];
    NSLog(@"html string = %@", _textParts.firstObject);
    if (_textParts.count > 0) {
        [self.secondPartLabel loadHTMLString:_textParts.lastObject baseURL:[NSURL URLWithString:@"http://"]];
    }
    self.dateLabel.text = date;
}


- (void)viewDidAppear:(BOOL)animated
{
    switch ([self mode]) {
        case ShowingNewsEntry:
            if (_entry.itemStatus == NLItemStatusNew || _entry.itemStatus == NLItemStatusUnread) {
                _entry.itemStatus = NLItemStatusRead;
                [self setUnreadStatus:_entry.itemStatus];
                [[NLStorage sharedInstance] archive];
            }
            break;

        case ShowingEvent:
            if (_event.itemStatus == NLItemStatusNew || _event.itemStatus == NLItemStatusUnread) {
                _event.itemStatus = NLItemStatusRead;
                [self setUnreadStatus:_event.itemStatus];
                [[NLStorage sharedInstance] archive];
            }
            break;

        case ShowingPlace:
            if (_place.itemStatus == NLItemStatusNew || _place.itemStatus == NLItemStatusUnread) {
                _place.itemStatus = NLItemStatusRead;
                [self setUnreadStatus:_place.itemStatus];
                [[NLStorage sharedInstance] archive];
            }
            break;

        default:
            break;
    }
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


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // TODO: Попробовать обернуть запрос в HTML
    NSString *padding = @"document.body.style.margin='0';document.body.style.padding ='0';document.body.style.font='12pt BookmanC,serif'";
    [webView stringByEvaluatingJavaScriptFromString:padding];
    if ([webView isEqual:self.firstPartWebView]) {
        NSString *firstLetter = [[[self attributedStringForString:_textParts[0]] string] substringToIndex:1];
        self.capitalLetter.text = firstLetter;
        [self.contentView sendSubviewToBack:self.capitalLetter];
        [self.capitalLetter setHidden:NO];
        NSString *moveParagraph = [NSString stringWithFormat:@"var p=document.getElementsByTagName('p').item(0);p.style.textIndent='%gpx';p.innerHTML=p.innerHTML.replace('%@','')", floorf((self.capitalLetter.bounds.size.width + 30) / 2), firstLetter];
        [webView stringByEvaluatingJavaScriptFromString:moveParagraph];
    }
    CGFloat jsHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    if ([webView isEqual:self.firstPartWebView]) {
        self.firstTextHeight.constant = jsHeight;
    } else {
        self.secondTextHeight.constant = jsHeight;
    }
    [self layout];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}


- (void)layout
{
    if (_textParts.count > 1) {
        self.galleryCover.hidden = NO;
        self.secondPartLabel.hidden = NO;
        self.showGalleryButton.hidden = NO;

        self.galleryHeight.constant = 240;
        self.galleryCover.imageURL = [NSURL URLWithString:[_gallery cover].image];
    } else {
        self.galleryCover.hidden = YES;
        self.secondPartLabel.hidden = YES;
        self.showGalleryButton.hidden = YES;

        self.secondTextHeight.constant = 0;
        self.galleryHeight.constant = 0;
    }
}

- (NLGallery *)galleryFromString:(NSString *)htmlString
{
    __block NLGallery *gallery = nil;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.+\\]" options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange galleryRange = {.location = result.range.location + 1, .length = result.range.length - 2};
        NSString *galleryName = [htmlString substringWithRange:galleryRange];
        gallery = _.array([[NLStorage sharedInstance] galleries]).find(^BOOL (NLGallery *gal) {
            return [gal.shortcut isEqualToString:galleryName];
        });
        if (gallery) {
            *stop = YES;
        }
    }];

    return gallery;
}

- (NSArray *)textParts:(NSString *)htmlString
{
    NSArray *parts = @[htmlString];
    if (_gallery != nil) {
        NSString *galleryTag = [NSString stringWithFormat:@"[%@]", _gallery.shortcut];
        parts = [htmlString componentsSeparatedByString:galleryTag];
    }
    return parts;
}


- (NSAttributedString *)attributedStringForString:(NSString *)htmlString
{
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithHTMLData:htmlData
                                                                                        options:@{DTUseiOS6Attributes: @(YES)}
                                                                             documentAttributes:nil];
    return attributed;
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (IBAction)showGallery:(id)sender
{
    NSLog(@"Show gallery");
    _galleryVC = [[NLGalleryViewController alloc] initWithGallery:_gallery andTitle:self.titleLabel.text];
    [self presentViewController:_galleryVC animated:YES completion:^{}];
}


@end
