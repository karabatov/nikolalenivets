//
//  NLEventsViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEventGroupsViewController.h"
#import "NLStorage.h"
#import "AsyncImageView.h"
#import "NLEventGroup.h"
#import "NLMainMenuController.h"
#import <NSDate+Helper.h>

@implementation NLEventGroupsViewController
{
    __strong NSArray *_eventGroups;
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

    //self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    self.view.frame = [[UIScreen mainScreen] bounds];

    self.titleLabel.font = [UIFont fontWithName:NLMonospacedFont size:18];
    self.currentPageLabel.font = [UIFont fontWithName:NLMonospacedFont size:self.currentPageLabel.font.pointSize];
    self.overallPagesCountLabel.font = self.currentPageLabel.font;

    self.eventTypeLabel.font =
    self.eventDatesTitleLabel.font =
    self.eventPriceTitleLabel.font = [UIFont fontWithName:NLMonospacedFont size:self.eventTypeLabel.font.pointSize];

    self.eventTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:24];
    self.eventDatesLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    self.ticketPriceLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];

    [self prepareEventsArray];
    [self fillContentForPage:0];
}


- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
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
        AsyncImageView *slideImage = [[AsyncImageView alloc] initWithFrame:self.scrollView.frame];
        slideImage.imageURL = [NSURL URLWithString:group.poster];
        slideImage.showActivityIndicator = YES;
        slideImage.frame = CGRectMake(leftOffset, 0, slideImage.frame.size.width, slideImage.frame.size.height);
        leftOffset += slideImage.frame.size.width;

        return  slideImage;
    })
    .unwrap;

    self.scrollView.contentSize = CGSizeMake(slides.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    _.array(self.scrollView.subviews).each(^(UIView *v) { [v removeFromSuperview]; });
    _.array(slides).each(^(UIImageView *slide) {
        [self.scrollView addSubview:slide];
    });

    self.overallPagesCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)slides.count];
}


#pragma mark - Scroll delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPage = floor(scrollView.contentOffset.x / scrollView.bounds.size.width);
	[self fillContentForPage:_currentPage];
}


- (void)fillContentForPage:(NSUInteger)pageIndex
{
    BOOL shouldFill = _eventGroups.count > pageIndex;
    self.previewView.hidden = !shouldFill;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(_currentPage + 1)];
    if (shouldFill) {
        NLEventGroup *group = _eventGroups[pageIndex];
        self.eventTitleLabel.text = group.name;
        self.ticketPriceLabel.text = group.ticketprice;
        NSDate *startDate = [NSDate dateFromString:group.startdate];
        NSDate *endDate = [NSDate dateFromString:group.enddate];

        NSString *startDateString = [startDate stringWithFormat:@"d"];
        NSString *endDateString = [endDate stringWithFormat:@"d MMMM"];

        self.eventDatesLabel.text = [NSString stringWithFormat:@" %@\n—%@", startDateString, endDateString];
    }
}


- (IBAction)scrollBack:(id)sender
{
    if (self.scrollView.contentOffset.x > 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - self.scrollView.frame.size.width,
                                                       self.scrollView.contentOffset.y)
                                  animated:YES];
        _currentPage--;
        [self fillContentForPage:_currentPage];
    }
}


- (IBAction)scrollForward:(id)sender
{
    if (_currentPage >= _eventGroups.count - 1 && _currentPage <= 0) {
        return;
    }
    if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width,
                                                       self.scrollView.contentOffset.y)
                                  animated:YES];
        _currentPage++;
        [self fillContentForPage:_currentPage];
    }
}

@end
