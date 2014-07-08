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

    CGFloat _firstTextPartHeight;
    CGFloat _secondTextPartHeight;

    NSArray *_textParts;
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
    
    self.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:24];
    self.detailsViewTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
    self.dateLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.countView.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];

    NSString *title = nil;
    NSString *content = nil;
    NSString *date = nil;
    NSInteger indexNumber = 0;

    switch ([self mode]) {
        case ShowingNewsEntry: {
            title = _entry.title;
            content = _entry.content;
            date = [[_entry pubDate] stringWithFormat:DefaultDateFormat];
            indexNumber = [[[NLStorage sharedInstance] news] indexOfObject:_entry];
            break;
        }
        case ShowingEvent: {
            title = _event.title;
            content = _event.content;
            date = [[_event startDate] stringWithFormat:DefaultDateFormat];
            self.detailsViewTitleLabel.text = @"СОБЫТИЯ";
            indexNumber = -1;
            break;
        }
        case ShowingPlace: {
            title = _place.title;
            content = _place.content;
            self.detailsViewTitleLabel.text = @"МЕСТА";
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
        self.countView.text = [NSString stringWithFormat:@"%02ld", indexNumber + 1];
    } else {
        if ([self mode] == ShowingPlace) {
            if (_currentLocation) {
                self.countView.text = [NSString stringWithFormat:@"%.2f км.", [_place distanceFromLocation:_currentLocation] / 1000];
            }
        } else {
            self.countView.text = @"";
        }

    }

    self.firstPartWebView.delegate = self;
    self.secondPartLabel.delegate = self;
    [self.firstPartWebView loadHTMLString:_textParts.firstObject baseURL:[NSURL URLWithString:@"http://"]];
    if (_textParts.count > 0) {
        [self.secondPartLabel loadHTMLString:_textParts.lastObject baseURL:[NSURL URLWithString:@"http://"]];
    }

    self.dateLabel.text = date;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    if ([webView isEqual:self.firstPartWebView]) {
        _firstTextPartHeight = [output doubleValue] + 50;
    } else {
        _secondTextPartHeight = [output doubleValue] + 30;
    }
    [self layout];
    NSLog(@"height: %@", output);
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
    self.firstPartWebView.frame = CGRectMake(self.firstPartWebView.frame.origin.x,
                                             self.firstPartWebView.frame.origin.y,
                                             self.firstPartWebView.frame.size.width,
                                             _firstTextPartHeight);
    if (_textParts.count > 1) {
        self.galleryCover.hidden = NO;
        self.secondPartLabel.hidden = NO;
        self.showGalleryButton.hidden = NO;

        self.galleryCover.imageURL = [NSURL URLWithString:_gallery.cover.image];
        self.galleryCover.frame = CGRectMake(self.galleryCover.frame.origin.x,
                                             self.firstPartWebView.frame.origin.y + self.firstPartWebView.frame.size.height,
                                             self.galleryCover.frame.size.width,
                                             self.galleryCover.frame.size.height);
        self.showGalleryButton.frame = self.galleryCover.frame;

        self.secondPartLabel.frame = CGRectMake(self.secondPartLabel.frame.origin.x,
                                                self.galleryCover.frame.origin.y + self.galleryCover.frame.size.height + 20,
                                                self.secondPartLabel.frame.size.width,
                                                _secondTextPartHeight);
    } else {
        self.galleryCover.hidden = YES;
        self.secondPartLabel.hidden = YES;
        self.showGalleryButton.hidden = YES;

        self.galleryCover.frame = CGRectZero;
        self.secondPartLabel.frame = CGRectZero;
        self.showGalleryButton.frame = CGRectZero;
    }

    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width,
                                        self.firstPartWebView.frame.size.height +
                                        self.galleryCover.frame.size.height +
                                        self.secondPartLabel.frame.size.height + 163);

    self.scrollView.contentSize = self.contentView.frame.size;

    NSString *firstLetter = [[[self attributedStringForString:_textParts[0]] string] substringToIndex:1];
    self.capitalLetter.text = firstLetter;
}

- (NLGallery *)galleryFromString:(NSString *)htmlString
{
    NSRange galleryBeginning = [htmlString rangeOfString:@"["];
    NLGallery *gallery = nil;
    if (galleryBeginning.location != NSNotFound) {
        NSRange galleryEnding = [htmlString rangeOfString:@"]"];
        NSString *galleryName = [htmlString substringWithRange:NSMakeRange(galleryBeginning.location + 1, galleryEnding.location - galleryBeginning.location - 1)];
        gallery = _.array([[NLStorage sharedInstance] galleries]).find(^(NLGallery *gal) {
            return (BOOL)[gal.shortcut isEqualToString:galleryName];
        });
    }
    return gallery;
}

- (NSArray *)textParts:(NSString *)htmlString
{
    NSArray *parts = @[htmlString];
    if (_gallery != nil) {
        NSRange galleryBeginning = [htmlString rangeOfString:@"["];
        if (galleryBeginning.location != NSNotFound) {
            NSRange galleryEnding = [htmlString rangeOfString:@"]"];
            NSString *galleryTag = [htmlString substringWithRange:NSMakeRange(galleryBeginning.location, galleryEnding.location - galleryBeginning.location + 1)];
            parts = [htmlString componentsSeparatedByString:galleryTag];
        }
    }
    return parts;
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


- (IBAction)showGallery:(id)sender
{
    NSLog(@"Show gallery");
    _galleryVC = [[NLGalleryViewController alloc] initWithGallery:_gallery];
    [self presentViewController:_galleryVC animated:YES completion:^{}];
}


@end
