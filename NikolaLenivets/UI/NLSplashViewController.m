//
//  NLSplashViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 25.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSplashViewController.h"
#import "NLLocationManager.h"
#import "NLStorage.h"
#import "NSAttributedString+Kerning.h"


@implementation NLSplashViewController

- (id)init
{
    self = [super initWithNibName:@"NLSplashViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingUpdated:) name:NLUserHeadingUpdated object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[AppDelegate window] frame];
    [self.view bringSubviewToFront:self.splashTop];
    [self.view bringSubviewToFront:self.blackStrip];
    self.nikolaLabel.attributedText = [NSAttributedString kernedStringForString:@"НИКОЛА" withFontSize:18 andColor:[UIColor blackColor]];
    self.lenivetsLabel.attributedText = [NSAttributedString kernedStringForString:@"ЛЕНИВЕЦ" withFontSize:18 andColor:[UIColor blackColor]];
}


- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:1.0f animations:^{
        self.compass.alpha = 1.0f;
    }];

    srand48(time(0));
    CGFloat anim1 = drand48() * 2;
    CGFloat anim2 = drand48() * 5;
    CGFloat anim3 = drand48() * 2;

    self.blackStripWidth.constant = 160;
    [UIView animateWithDuration:anim1 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.blackStripWidth.constant = 128;
        [UIView animateWithDuration:anim2 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.blackStripWidth.constant = 64;
            [UIView animateWithDuration:anim3 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissSplash) withObject:nil afterDelay:3];
            }];
        }];
    }];
}


- (void)dismissSplash
{
    [AppDelegate dismissSplash];
}


- (void)headingUpdated:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.compass.transform = [[NLLocationManager sharedInstance] compassTransform];
    } completion:NULL];
}

@end
