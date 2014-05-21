//
//  NLEventsViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLEventsViewController.h"
#import "NLStorage.h"
#import "AsyncImageView.h"
#import "NLGroup.h"
#import "NLMainMenuController.h"

@implementation NLEventsViewController
{
    __strong NSArray *_events;
    NSUInteger _currentPage;
}

- (id)init
{
    self = [super initWithNibName:@"NLEventsViewController" bundle:nil];
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
    [self prepareEventsArray];
    [self fillContentForPage:0];
}


- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}


- (void)prepareEventsArray
{
    _events = [[NLStorage sharedInstance] events];
    [self layoutSlides];
}


- (void)layoutSlides
{
    __block CGFloat leftOffset = 0.0;

    NSArray *slides = _.array(_events).map(^(NLEvent *event) {
        AsyncImageView *slideImage = [[AsyncImageView alloc] initWithFrame:self.scrollView.frame];
        NLGroup *group = [event.groups lastObject];
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
    self.currentPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_currentPage];
	[self fillContentForPage:_currentPage];
}


- (void)fillContentForPage:(NSUInteger)pageIndex
{
    BOOL shouldFill = _events.count > pageIndex;
    self.previewView.hidden = !shouldFill;
    if (shouldFill) {
        NLEvent *event = _events[pageIndex];
        NLGroup *group = [event.groups lastObject];
        self.eventTitleLabel.text = event.title;
        self.ticketPriceLabel.text = [NSString stringWithFormat:@"%@ Р", group.ticketprice];
        self.eventDatesLabel.text = [NSString stringWithFormat:@"  %@\n–%@", group.startdate, group.enddate];
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
    if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width,
                                                       self.scrollView.contentOffset.y)
                                  animated:YES];
        _currentPage++;
        [self fillContentForPage:_currentPage];
    }
}

@end
