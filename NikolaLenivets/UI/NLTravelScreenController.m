//
//  NLTravelScreenController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelScreenController.h"
#import "NLTravelTypeSectionView.h"

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

    [self.view addSubview:self.contentWrapper];
    [self.view addSubview:self.menuWrapper];
    [self.view addSubview:self.navBarView];

    [self.menuWrapper addSubview:self.screenTitle];

    NSDictionary *views = @{ @"navbar": self.navBarView, @"menu": self.menuWrapper, @"content": self.contentWrapper, @"sTitle": self.screenTitle };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navbar]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menu]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navbar(64)][menu]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navbar][content]|" options:kNilOptions metrics:nil views:views]];
    [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16.5-[sTitle(287)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sTitle(150)]" options:kNilOptions metrics:nil views:views]];

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
    NSLog(@"foldMenuAway: %d", sender.view.tag);
    self.itemToFoldBack = sender.view.tag;
    self.travelTitleConstraint.constant = -(self.travelTitleConstraint.constant + 150.f);
    for (NSUInteger i = 0; i <= 4; i++) {
        NSLayoutConstraint *constraint = [self.menuConstraints objectAtIndex:i];
        constraint.constant = i <= self.itemToFoldBack ? constraint.constant + self.menuWrapper.bounds.size.height : constraint.constant - self.menuWrapper.bounds.size.height;
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
