//
//  NLTravelScreenController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelScreenController.h"
#import "NLTravelTypeSectionView.h"
#import "NSAttributedString+Kerning.h"

@interface NLTravelScreenController ()

/**
 Index of item to fold back.
 */
@property (nonatomic) NLTravelType itemToFoldBack;

/**
 Constraints for menu items.
 */
@property (strong, nonatomic) NSMutableArray *menuConstraints;

/**
 Constraint for the position of the title image.
 */
@property (strong, nonatomic) NSLayoutConstraint *travelTitleConstraint;

/**
 Navbar wrapper view.
 */
@property (strong, nonatomic) UIView *navBarView;

/**
 Menu wrapper view, overlaps content wrapper view.
 */
@property (strong, nonatomic) UIView *menuWrapper;

/**
 Content wrapper view. Content views go inside it.
 */
@property (strong, nonatomic) UIScrollView *contentWrapper;

/**
 Title image for travel screen.
 */
@property (strong, nonatomic) UIImageView *screenTitle;

/**
 Return to menu button.
 */
@property (strong, nonatomic) UIButton *menuButton;

/**
 Screen title label in the navbar.
 */
@property (strong, nonatomic) UILabel *navTitleLabel;

/**
 Offset for the navbar title label to animate.
 */
@property (strong, nonatomic) NSLayoutConstraint *navTitleOffset;

/**
 Button with image to fold back to title.
 */
@property (strong, nonatomic) UIButton *backImageButton;

@end

@implementation NLTravelScreenController

- (void)viewDidLoad
{
    self.contentWrapper = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.contentWrapper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentWrapper setBackgroundColor:[UIColor redColor]];

    self.menuWrapper = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.menuWrapper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.menuWrapper setBackgroundColor:[UIColor whiteColor]];

    self.navBarView = [[UIView alloc] init];
    [self.navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navBarView setBackgroundColor:[UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f]];

    self.screenTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-text-title.png"]];
    [self.screenTitle setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.menuButton setImage:[UIImage imageNamed:@"menu_button.png"] forState:UIControlStateNormal];
    [self.menuButton setContentEdgeInsets:UIEdgeInsetsMake(16, 3, 16, 3)];
    [self.menuButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    self.navTitleLabel = [[UILabel alloc] init];
    [self.navTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.navTitleLabel.attributedText = [NSAttributedString kernedStringForString:[self.title uppercaseString] withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]];

    self.backImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backImageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backImageButton setImage:[UIImage imageNamed:@"button-back-black.png"] forState:UIControlStateNormal];
    [self.backImageButton setContentEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [self.backImageButton addTarget:self action:@selector(foldMenuBack) forControlEvents:UIControlEventTouchUpInside];
    self.backImageButton.alpha = 0.f;

    [self.view addSubview:self.contentWrapper];
    [self.view addSubview:self.menuWrapper];
    [self.view addSubview:self.navBarView];

    [self.menuWrapper addSubview:self.screenTitle];

    [self.navBarView addSubview:self.menuButton];
    [self.navBarView addSubview:self.navTitleLabel];
    [self.navBarView addSubview:self.backImageButton];

    NSDictionary *views = @{ @"navbar": self.navBarView,
                             @"menu": self.menuWrapper,
                             @"content": self.contentWrapper,
                             @"sTitle": self.screenTitle,
                             @"menuBtn": self.menuButton,
                             @"backBtn": self.backImageButton };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navbar]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menu]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navbar(64)][menu]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navbar][content]|" options:kNilOptions metrics:nil views:views]];
    [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16.5-[sTitle(287)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sTitle(150)]" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[menuBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[menuBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[backBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[backBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];

    self.navTitleOffset = [NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-9.f];
    [self.navBarView addConstraint:self.navTitleOffset];
    [self.navBarView addConstraint:[NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.navBarView addConstraint:[NSLayoutConstraint constraintWithItem:self.backImageButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];

    self.travelTitleConstraint = [NSLayoutConstraint constraintWithItem:self.screenTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.menuWrapper attribute:NSLayoutAttributeTop multiplier:1.f constant:9.f];
    [self.menuWrapper addConstraint:self.travelTitleConstraint];

    self.menuConstraints = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSUInteger i = 0; i <= 4; i++) {
        NLTravelTypeSectionView *sectionView = [[NLTravelTypeSectionView alloc] init];
        sectionView.tag = i;
        [self.menuWrapper addSubview:sectionView];
        [sectionView addTarget:self withAction:@selector(foldMenuAway:)];
        NSDictionary *views = @{ @"section": sectionView };
        [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[section]|" options:kNilOptions metrics:nil views:views]];
        [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[section(45)]" options:kNilOptions metrics:nil views:views]];
        NSLayoutConstraint *sectionConstraint = [NSLayoutConstraint constraintWithItem:self.menuWrapper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sectionView attribute:NSLayoutAttributeBottom multiplier:1.f constant:45.f * (4 - i)];
        [self.menuConstraints addObject:sectionConstraint];
        [self.menuWrapper addConstraint:sectionConstraint];
    }
}

- (void)foldMenuAway:(UIGestureRecognizer *)sender
{
    self.itemToFoldBack = sender.view.tag;
    self.travelTitleConstraint.constant = self.travelTitleConstraint.constant - self.menuWrapper.bounds.size.height;
    for (NSUInteger i = 0; i <= 4; i++) {
        NSLayoutConstraint *constraint = [self.menuConstraints objectAtIndex:i];
        constraint.constant = i <= self.itemToFoldBack ? constraint.constant + self.menuWrapper.bounds.size.height : constraint.constant - self.menuWrapper.bounds.size.height;
    }
    self.navTitleOffset.constant = 10.f;
    [UIView animateWithDuration:0.5f animations:^{
        self.navTitleLabel.transform = CGAffineTransformMakeScale(0.65f, 0.65f);
        self.backImageButton.alpha = 1.f;
        [self.view layoutIfNeeded];
    }];
}

- (void)foldMenuBack
{
    self.travelTitleConstraint.constant = self.travelTitleConstraint.constant + self.menuWrapper.bounds.size.height;
    for (NSUInteger i = 0; i <= 4; i++) {
        NSLayoutConstraint *constraint = [self.menuConstraints objectAtIndex:i];
        constraint.constant = i <= self.itemToFoldBack ? constraint.constant - self.menuWrapper.bounds.size.height : constraint.constant + self.menuWrapper.bounds.size.height;
    }
    self.navTitleOffset.constant = -9.f;
    [UIView animateWithDuration:0.5f animations:^{
        self.navTitleLabel.transform = CGAffineTransformIdentity;
        self.backImageButton.alpha = 0.f;
        [self.view layoutIfNeeded];
    }];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
