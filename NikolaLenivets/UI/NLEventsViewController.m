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
        UIImageView *slideImage = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
        NLGroup *group = [event.groups lastObject];
        slideImage.imageURL = [NSURL URLWithString:group.poster];
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
}

@end
