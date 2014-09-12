//
//  NLSearchViewController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 12.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchViewController.h"

@interface NLSearchViewController ()

/**
 Large search button from menu, disappears on start.
 */
@property (strong, nonatomic) UIImageView *searchImageView;

/**
 Back button to return to menu.
 */
@property (strong, nonatomic) UIButton *backButton;

/**
 Top space for search image.
 */
@property (strong, nonatomic) NSLayoutConstraint *searchImageTop;

/**
 Side size for search image.
 */
@property (strong, nonatomic) NSLayoutConstraint *searchImageSide;

@end

@implementation NLSearchViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1.f]];

    self.searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-normal.png"]];
    self.searchImageView.alpha = 0.5f;
    [self.searchImageView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"search-button-back.png"] forState:UIControlStateNormal];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.hidden = YES;
    self.backButton.alpha = 0.f;

    [self.view addSubview:self.searchImageView];
    [self.view addSubview:self.backButton];

    NSDictionary *views = @{ @"sImg": self.searchImageView, @"back": self.backButton };
    NSDictionary *metrics = @{ @"backSize": @44, @"backTop": @3.5 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[back(backSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-backTop-[back(backSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    CGFloat searchTop = [UIScreen mainScreen].bounds.size.height / 6.f - 17.f - 62.f;
    self.searchImageTop = [NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.f constant:searchTop];
    [self.view addConstraint:self.searchImageTop];
    self.searchImageSide = [NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:62.f];
    [self.view addConstraint:self.searchImageSide];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchImageView attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
}

- (void)viewDidAppear:(BOOL)animated
{
    BOOL firstTime = YES;

    if (firstTime) {
        self.searchImageView.tintColor = [UIColor blackColor];
        self.searchImageTop.constant = 16.f;
        self.searchImageSide.constant = 19.f;
        [UIView animateWithDuration:0.25f animations:^{
            self.searchImageView.alpha = 1.f;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.searchImageView.image = [self.searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.backButton.hidden = NO;
            [UIView animateWithDuration:0.15f animations:^{
                self.backButton.alpha = 1.f;
                self.searchImageView.alpha = 0.5f;
            } completion:^(BOOL finished) {
                self.searchImageView.hidden = YES;
            }];
        }];
    }
}

- (void)goBack:(id)sender
{
    self.searchImageView.hidden = NO;
    [UIView animateWithDuration:0.15f animations:^{
        self.backButton.alpha = 0.f;
        self.searchImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.backButton.hidden = YES;
        self.searchImageView.image = [self.searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.searchImageTop.constant = [UIScreen mainScreen].bounds.size.height / 6.f - 17.f - 62.f;
        self.searchImageSide.constant = 62.f;
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
