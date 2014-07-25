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
    [self performSelector:@selector(dismissSplash) withObject:nil afterDelay:4];
    self.blackStripWidth.constant = 64;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
        self.compass.alpha = 1.0f;
    } completion:^(BOOL finished) {
        //
    }];
}


- (void)dismissSplash
{
    [AppDelegate dismissSplash];
}


- (void)headingUpdated:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.compass layer].transform = [[NLLocationManager sharedInstance] compassTransform3D];
    } completion:NULL];
}

@end
