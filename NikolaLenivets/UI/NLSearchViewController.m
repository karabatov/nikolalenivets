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

    [self.view addSubview:self.backButton];
    [self.view addSubview:self.searchImageView];

    NSDictionary *views = @{ @"sImg": self.searchImageView, @"back": self.backButton };
    NSDictionary *metrics = @{ @"sImgSize": @62, @"backSize": @44, @"sImgTop": @15.5, @"backTop": @4 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sImg(sImgSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[back(backSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-sImgTop-[sImg(sImgSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-backTop-[back(backSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
