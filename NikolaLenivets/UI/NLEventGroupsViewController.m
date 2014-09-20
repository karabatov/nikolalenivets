//
//  NLEventsViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEventGroupsViewController.h"
#import "NLStorage.h"
#import "NLEventGroup.h"
#import "NLMainMenuController.h"
#import "NLEventsCollectionViewController.h"
#import <NSDate+Helper.h>
#import "NSAttributedString+Kerning.h"
#import "NSDate+CompareDays.h"
#import "UIViewController+CustomButtons.h"

#import <UIImageView+WebCache.h>

@implementation NLEventGroupsViewController
{
    NLEventsCollectionViewController *_events;
    NSArray *_eventGroups;
    NSUInteger _currentPage;
}

- (id)init
{
    self = [super initWithNibName:@"NLEventGroupsViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(prepareEventsArray)
                                                     name:STORAGE_DID_UPDATE
                                                   object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.frame = [[[[UIApplication sharedApplication] delegate] window] frame];

    self.currentPageLabel.font = [UIFont fontWithName:NLMonospacedFont size:self.currentPageLabel.font.pointSize];
    self.overallPagesCountLabel.font = self.otherPageLabel.font = self.currentPageLabel.font;

    self.eventTypeLabel.font =
    self.eventDatesTitleLabel.font =
    self.eventPriceTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.eventTypeLabel.font.pointSize];

    self.eventTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:40];
    self.eventDatesLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    self.eventDateDashLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    self.ticketPriceLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:20];

    self.previewView.opaque = NO;
    self.previewView.backgroundColor = [UIColor clearColor];
    [self.previewView setUserInteractionEnabled:NO];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.previewView.bounds];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toolbar.barStyle = UIBarStyleBlack;
    [self.previewView insertSubview:toolbar atIndex:0];

    self.scrollView.delegate = self;

    _currentPage = 0;

//    [self prepareEventsArray];
//    [self fillContentForPage:0];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.hidden = NO;
    [self prepareEventsArray];
    if (_currentPage >= [_eventGroups count]) {
        _currentPage = 0;
    }
    [self fillContentForPage:_currentPage];
    [self.eventDateDashLabel setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (IBAction)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)prepareEventsArray
{
    _eventGroups = [[NLStorage sharedInstance] eventGroups];
    [self layoutSlides];
}


- (void)layoutSlides
{
    __block CGFloat leftOffset = 0.0;

    NSArray *slides = _.array(_eventGroups).map(^(NLEventGroup *group) {
        UIImageView *slideImage = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
        [slideImage setClipsToBounds:YES];

        __block UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center = CGPointMake(slideImage.center.x, slideImage.center.y - 40);
        [slideImage addSubview:activity];
        [activity startAnimating];

        [slideImage sd_setImageWithURL:[NSURL URLWithString:group.poster]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *url) {
                              [activity removeFromSuperview];
                          }];
        slideImage.contentMode = UIViewContentModeScaleAspectFill;
        slideImage.frame = CGRectMake(leftOffset, 0, slideImage.frame.size.width, slideImage.frame.size.height);
        leftOffset += slideImage.frame.size.width;

        return slideImage;
    })
    .unwrap;

    self.scrollView.contentSize = CGSizeMake(slides.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    _.array(self.scrollView.subviews).each(^(UIView *v) { [v removeFromSuperview]; });
    _.array(slides).each(^(UIImageView *slide) {
        [self.scrollView addSubview:slide];
        UIButton *button = [[UIButton alloc] initWithFrame:slide.frame];
        [button addTarget:self action:@selector(openEventsList:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    });

    self.overallPagesCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)slides.count];
}


- (void)updateUnreadCountWithCount:(NSInteger)unreadCount
{
    ((NLNavigationBar *)self.navigationController.navigationBar).counter = unreadCount;
    if (unreadCount == 0) {
        [self setupForNavBarWithStyle:NLNavigationBarStyleNoCounter];
    } else {
        [self setupForNavBarWithStyle:NLNavigationBarStyleCounter];
    }
}


#pragma mark - Scroll delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // _currentPage = floor((scrollView.contentOffset.x + scrollView.bounds.size.width / 2) / scrollView.bounds.size.width);
	// [self fillContentForPage:_currentPage];
}


- (void)fillContentForPage:(NSUInteger)pageIndex
{
    BOOL shouldFill = _eventGroups.count > pageIndex;
    self.previewView.hidden = !shouldFill;
    // self.currentPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(_currentPage + 1)];
    if (shouldFill) {
        NLEventGroup *group = _eventGroups[pageIndex];
        [self updateUnreadCountWithCount:[[NLStorage sharedInstance] unreadCountInArray:group.events]];

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.hyphenationFactor = 0.1f;
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:group.name attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
        NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:group.ticketprice attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];

        self.eventTitleLabel.attributedText = attributedTitle;
        self.ticketPriceLabel.attributedText = attributedPrice;
        NSDate *startDate = [NSDate dateFromString:group.startdate];
        NSDate *endDate = [NSDate dateFromString:group.enddate];

        NSString *startDateString = [startDate stringWithFormat:@"d"];
        NSString *startMonthString = [[startDate stringWithFormat:@"MMMM"] uppercaseString];
        NSString *endDateString = [endDate stringWithFormat:@"d"];
        NSString *endMonthString = [[endDate stringWithFormat:@"MMMM"] uppercaseString];

        if ([startMonthString isEqualToString:endMonthString]) {
            self.eventDatesLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", startDateString, endDateString, endMonthString];
            self.dashOffset.constant = 3.0f;
        } else {
            self.eventDatesLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", startDateString, startMonthString, endDateString, endMonthString];
            self.dashOffset.constant = 14.0f;
        }
    }

    self.prevItemButton.enabled = pageIndex != 0;
    self.nextItemButton.enabled = pageIndex != _eventGroups.count - 1;
    [self.previewView setNeedsLayout];
    [self.previewView layoutIfNeeded];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < scrollView.contentSize.width) {
        CGFloat frameWidth = scrollView.frame.size.width;
        CGFloat previewOffset = -fmod(self.scrollView.contentOffset.x, frameWidth) * 2;
        if (-previewOffset > frameWidth) {
            previewOffset += (fmod(self.scrollView.contentOffset.x, frameWidth) * 2 - frameWidth) * 2;
        }
        self.previewBottomSpace.constant = previewOffset;

        NSUInteger nextPage = floor((scrollView.contentOffset.x + frameWidth / 2) / frameWidth);
        if (_currentPage != nextPage) {
            _currentPage = nextPage;
            [self fillContentForPage:_currentPage];
        }
        [self.previewView setNeedsLayout];

        CGFloat offset = fmod(self.scrollView.contentOffset.x, frameWidth) / frameWidth;
        if (offset >= 0.5) {
            if ((_currentPage + 1) <= [_eventGroups count]) {
                self.otherPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(_currentPage + 1)];
            } else {
                self.otherPageLabel.text = @"";
            }
            self.currentPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_currentPage];
        } else {
            if ((_currentPage + 2) <= [_eventGroups count]) {
                self.otherPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(_currentPage + 2)];
            } else {
                self.otherPageLabel.text = @"";
            }
            self.currentPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(_currentPage + 1)];
        }
        self.otherPageLabel.alpha = offset;
        self.otherPageLabelOffset.constant = 12 * offset;
        self.currentPageLabel.alpha = 1 - offset;
        self.currentPageLabelOffset.constant = 12 + 12 * offset;
        [self.pagerView setNeedsLayout];
    }
}


- (IBAction)scrollBack:(id)sender
{
    if (self.scrollView.contentOffset.x > 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - fmod(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) - self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
    }
}


- (IBAction)scrollForward:(id)sender
{
    if (_currentPage >= _eventGroups.count - 1 && _currentPage <= 0) {
        return;
    }
    if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - fmod(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) + self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
    }
}


- (IBAction)openEventsList:(id)sender
{
    NSLog(@"Open event list");
    NLEventGroup *group = _eventGroups[_currentPage];
    _events = [[NLEventsCollectionViewController alloc] initWithGroup:group];
    _events.title = [group.name uppercaseString];
    [self.navigationController pushViewController:_events animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateUnreadCountWithCount:[[NLStorage sharedInstance] unreadCountInArray:group.events]];
    });
}

@end
