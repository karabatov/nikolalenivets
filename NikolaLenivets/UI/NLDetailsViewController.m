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
#import "NLMapViewController.h"

#import <DTCoreText.h>
#import <NSDate+Helper.h>
#import "NSString+Distance.h"
#import "NSString+Ordinal.h"
#import "UIViewController+BackViewController.h"
#import "NSDate+CompareDays.h"
#import "NLGalleryTransition.h"
#import "UIColor+HexValues.h"

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
    NLMapViewController *_mapVC;
    NSArray *_textParts;
    NSInteger _eventGroupOrder;
    NLGalleryTransition *_galleryTransition;
    UIView *_capitalView;
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

    [self.view bringSubviewToFront:self.scrollView];
    [self.view bringSubviewToFront:self.eventDayView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.unreadIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.f constant:16.5f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.countView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:1.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeCenterY multiplier:1.f constant:1.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.f constant:-15.f]];

    UIColor *textColor = [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.f];

    self.detailsViewTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.countView.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
    self.countView.textColor = textColor;
    self.scrollView.delegate = self;

    NSString *title = nil;
    NSString *content = nil;
    NSString *date = nil;
    NSInteger indexNumber = 0;
    CGFloat webViewOffset = 306.f;

    UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];

    switch ([self mode]) {
        case ShowingNewsEntry: {
            title = _entry.title;
            content = _entry.content;
            date = [[[_entry pubDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            self.detailsViewTitleLabel.text = [self backViewController] ? [self backViewController].title : @"НОВОСТИ";
            indexNumber = [[[NLStorage sharedInstance] news] count] - [[[NLStorage sharedInstance] news] indexOfObject:_entry];
            [self setUnreadStatus:_entry.itemStatus];
            for (UIView *view in [self.eventDayView subviews]) {
                [view removeFromSuperview];
            }
            [self.eventDayView setBackgroundColor:borderGray];
            self.eventDayHeight.constant = 1;
            break;
        }
        case ShowingEvent: {
            title = _event.title;
            content = _event.content;
            date = [[[_event startDate] stringWithFormat:DefaultTimeFormat] uppercaseString];
            if ([NSDate isSameDayWithDate1:[NSDate date] date2:[_event startDate]]) {
                [self.alarmIcon setHidden:NO];
            } else {
                [self.alarmIcon setHidden:YES];
            }
            self.detailsViewTitleLabel.text = [self backViewController].title;
            [self setUnreadStatus:_event.itemStatus];
            self.eventDayHeight.constant = 26;
            self.eventDayView.dateLabel.text = [[[_event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            self.eventDayView.dayOrderLabel.text = [[NSString stringWithFormat:@"%@ %@", @"день", [NSString ordinalRepresentationWithNumber:_eventGroupOrder]] uppercaseString];
            [self.eventDayView.layer setBorderColor:borderGray.CGColor];
            [self.eventDayView.layer setBorderWidth:0.5f];
            webViewOffset += 25.5f;
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
            self.detailsViewTitleLabel.text = [self backViewController] ? [self backViewController].title : @"МЕСТА";
            [self setUnreadStatus:_place.itemStatus];
            self.titleLabelBottomSpace.constant = 0;
            [self.titleLabel setHidden:YES];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:0.f]];
            self.placeImageHeight.constant = [UIScreen mainScreen].bounds.size.height * 0.65;
            [self.placeImage setShowActivityIndicator:YES];
            self.placeImage.imageURL = _place.picture && ![_place.picture isEqualToString:@""] ? [NSURL URLWithString:_place.picture] : [NSURL URLWithString:_place.thumbnail];
            self.eventDayHeight.constant = 26;
            self.eventDayView.dateLabel.text = [_place.title uppercaseString];
            [self.eventDayView.dayOrderLabel setHidden:YES];
            [self.infoButton setHidden:NO];
            webViewOffset += 25.5f;
            indexNumber = -1; //[[[NLStorage sharedInstance] places] indexOfObject:_place];
            break;
        }
        default:
            indexNumber = -1;
            break;
    }

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.firstPartWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.f constant:[UIScreen mainScreen].bounds.size.height - webViewOffset]];

    self.titleLabel.attributedText = [self attributedStringForTitle:title];
    _gallery = [self galleryFromString:content];
    _textParts = [self textParts:content];

    if (_gallery) {
        _galleryVC = [[NLGalleryViewController alloc] initWithGallery:_gallery andTitle:title];
        _galleryTransition = [[NLGalleryTransition alloc] initWithParentViewController:self andGalleryController:_galleryVC];
        // UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_galleryTransition action:@selector(userDidPan:)];
        // [self.galleryCover addGestureRecognizer:panGesture];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_galleryTransition action:@selector(presentGallery)];
        [self.galleryCover addGestureRecognizer:tapGesture];
        [self.galleryCover setUserInteractionEnabled:YES];
    }

    if (indexNumber > -1) {
        self.countView.text = [NSString stringWithFormat:@"%02ld", (long)indexNumber];
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

    // @"document.body.style.margin='0';document.body.style.padding ='0';document.body.style.font='12pt BookmanC,serif'"
    NSString *HTMLFormat = @"<html><head><style type=\"text/css\">* { margin:0 !important; margin-left:1px !important; padding:0 !important; -webkit-hyphens:auto !important; font-family:BookmanC !important; font-size:13pt !important; line-height:22px !important} p { color:#252525 !important; } a { color:#252525 !important; background-color:#%@ !important; text-decoration:none !important; }</style></head><body>%@</body></html>";
    NSString *hex = [[self capitalLetterColor] stringWithHexValue];
    [self.firstPartWebView loadHTMLString:[NSString stringWithFormat:HTMLFormat, hex, _textParts.firstObject] baseURL:[NSURL URLWithString:@"http://"]];
    if (_textParts.count > 0) {
        [self.secondPartLabel loadHTMLString:[NSString stringWithFormat:HTMLFormat, _textParts.lastObject] baseURL:[NSURL URLWithString:@"http://"]];
    }
    self.dateLabel.attributedText = [self attributedStringForDateMonth:date];
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
            [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-red.png"]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusUnread:
            [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-gray.png"]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusRead:
            // [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-red.png"]];
            [self.unreadIndicator setImage:nil];
            [self.unreadIndicator setHidden:YES];
            break;

        default:
            break;
    }
}


- (NSAttributedString *)attributedStringForTitle:(NSString *)titleString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.maximumLineHeight = 35.f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:40],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  // TODO: Make text tighter somehow.
                                  NSKernAttributeName: [NSNumber numberWithFloat:0.f],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
    return title;
}


- (UIColor *)capitalLetterColor
{
    switch ([self mode]) {
        case ShowingNewsEntry:
            return [UIColor colorWithRed:248.0f/255.0f green:255.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
            break;

        case ShowingEvent:
            return [UIColor colorWithRed:135.0f/255.0f green:163.0f/255.0f blue:1.0f alpha:1.0f];
            break;

        case ShowingPlace:
            return [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
            break;

        default:
            break;
    }
}


- (NSAttributedString *)attributedStringForCapitalLetter:(NSString *)letter
{
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:357],
                                  NSForegroundColorAttributeName: [self capitalLetterColor] };
    NSAttributedString *capitalLetter = [[NSAttributedString alloc] initWithString:letter attributes:attributes];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)capitalLetter);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);

    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);

        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);

            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                if (_capitalView) {
                    [_capitalView removeFromSuperview];
                }
                _capitalView = [[UIView alloc] init];
                [_capitalView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self.contentView addSubview:_capitalView];
                [self.contentView sendSubviewToBack:_capitalView];
                NSDictionary *views = @{ @"cap": _capitalView, @"gallery": self.galleryCover };
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cap]|" options:kNilOptions metrics:nil views:views]];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cap(229)]-(>=52)-[gallery]" options:kNilOptions metrics:nil views:views]];
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_capitalView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.firstPartWebView attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
                CGRect boundingBox = CGPathGetBoundingBox(letter);
                CGFloat scaleFactor = 229.f / CGRectGetHeight(boundingBox);
                // Scaling the path ...
                CGAffineTransform scaleTransform = CGAffineTransformIdentity;
                // Scale down the path first
                scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, -scaleFactor);
                // Then translate the path to the upper left corner
                scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMaxY(boundingBox) - 6);
                CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(letter, &scaleTransform);
                // Create a new shape layer and assign the new path
                CAShapeLayer *scaledShapeLayer = [CAShapeLayer layer];
                scaledShapeLayer.path = scaledPath;
                scaledShapeLayer.fillColor = [self capitalLetterColor].CGColor;
                [_capitalView.layer addSublayer:scaledShapeLayer];
                CGPathRelease(scaledPath); // release the copied path
                CGPathRelease(letter);
                break;
            }
        }
    }
    CFRelease(line);
    return capitalLetter;
}


- (NSAttributedString *)attributedStringForDateMonth:(NSString *)monthString
{
    if (monthString) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:12],
                                      NSForegroundColorAttributeName: [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.f],
                                      NSKernAttributeName: [NSNumber numberWithFloat:1.1f] };
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:monthString attributes:attributes];
        return title;
    } else {
        return [[NSAttributedString alloc] initWithString:@""];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView isEqual:self.firstPartWebView]) {
        NSString *firstLetter = [[[self attributedStringForString:_textParts[0]] string] substringToIndex:1];
        [self attributedStringForCapitalLetter:firstLetter];
        NSString *moveParagraph = [NSString stringWithFormat:@"var p=document.getElementsByTagName('p').item(0);p.innerHTML=p.innerHTML.replace('%@','');p.style.textIndent='61px';", firstLetter];
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
        // self.showGalleryButton.hidden = NO;
        self.showGalleryButton.hidden = YES;

        self.galleryHeight.constant = 240;
        self.galleryCover.imageURL = [NSURL URLWithString:[_gallery cover].image];
    } else {
        self.galleryCover.hidden = YES;
        self.secondPartLabel.hidden = YES;
        self.showGalleryButton.hidden = YES;

        self.secondTextHeight.constant = 0;
        self.galleryHeight.constant = 0;
    }
    [self.contentView setNeedsLayout];
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
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)showGallery:(id)sender
{
    NSLog(@"Show gallery");
    NSString *title = @"";
    switch ([self mode]) {
        case ShowingPlace:
            title = _place.title;
            break;
        case ShowingEvent:
            title = _event.title;
            break;
        case ShowingNewsEntry:
            title = _entry.title;
            break;

        default:
            break;
    }
    _galleryVC = [[NLGalleryViewController alloc] initWithGallery:_gallery andTitle:title];
    [self.navigationController pushViewController:_galleryVC animated:YES];
}


- (IBAction)openPlaceOnMap:(UIButton *)sender
{
    NSLog(@"openPlaceOnMap");
    switch ([self mode]) {
        case ShowingPlace:
        {
            _mapVC = [[NLMapViewController alloc] initWithPlace:_place];
            [self.navigationController pushViewController:_mapVC animated:YES];
            break;
        }

        default:
            break;
    }
}

- (IBAction)infoButtonAction:(UIButton *)sender
{
    CGPoint offset = self.firstPartWebView.frame.origin;
    offset.x = 0;
    offset.y -= 6;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.05f animations:^{
        self.blueGradient.alpha = 0.65f;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration:0.25f animations:^{
        self.blueGradient.alpha = 0.0f;
    }];
}

@end
