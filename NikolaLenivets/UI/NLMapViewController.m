//
//  NLMapViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMapViewController.h"


@implementation NLMapViewController

- (id)init
{
    self = [super initWithNibName:@"NLMapViewController" bundle:nil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapScrollView.contentSize = self.mapImageView.frame.size;
    self.mapScrollView.minimumZoomScale = 0.3;
    self.mapScrollView.maximumZoomScale = 2.0;
}


#pragma mark - Scrolling delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
}

@end
