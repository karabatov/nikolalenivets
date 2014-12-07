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
#import "NLTravelHeliView.h"
#import "NLTravelFestivalView.h"
#import "NLTravelBusView.h"
#import "NLTravelTrainView.h"
#import "NLTravelCarView.h"

@interface NLTravelScreenController ()

/**
 Index of item to fold back.
 */
@property (nonatomic) NLTravelType itemToFoldBack;

/**
 Height of the menu items, needs to be dynamic for iPhone 4.
 */
@property (nonatomic) CGFloat menuItemHeight;

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
 Wrapper for menu text image.
 */
@property (strong, nonatomic) UIView *topMenuWrapper;

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
    self.menuItemHeight = ceilf([UIScreen mainScreen].bounds.size.height / 10.f);

    self.contentWrapper = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.contentWrapper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentWrapper setBackgroundColor:[UIColor whiteColor]];

    self.menuWrapper = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.menuWrapper setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.navBarView = [[UIView alloc] init];
    [self.navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navBarView setBackgroundColor:[UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f]];

    UIView *dash0 = [[UIView alloc] init];
    [dash0 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash0 setBackgroundColor:[UIColor colorWithRed:172.f/255.f green:172.f/255.f blue:172.f/255.f alpha:1.f]];

    self.topMenuWrapper = [[UIView alloc] init];
    [self.topMenuWrapper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topMenuWrapper setBackgroundColor:[UIColor whiteColor]];

    self.screenTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"travel-text-title.png", @"travel-text-title.png")]];
    [self.screenTitle setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *dash1 = [[UIView alloc] init];
    [dash1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash1 setBackgroundColor:[UIColor colorWithRed:244.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1.f]];

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

    [self.topMenuWrapper addSubview:self.screenTitle];
    [self.topMenuWrapper addSubview:dash1];

    [self.menuWrapper addSubview:self.topMenuWrapper];

    [self.navBarView addSubview:self.menuButton];
    [self.navBarView addSubview:self.navTitleLabel];
    [self.navBarView addSubview:self.backImageButton];
    [self.navBarView addSubview:dash0];

    NSDictionary *views = @{ @"navbar": self.navBarView,
                             @"menu": self.menuWrapper,
                             @"content": self.contentWrapper,
                             @"topMenu": self.topMenuWrapper,
                             @"sTitle": self.screenTitle,
                             @"dash0": dash0,
                             @"dash1": dash1,
                             @"menuBtn": self.menuButton,
                             @"backBtn": self.backImageButton };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navbar]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menu]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navbar(64)][menu]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navbar][content]|" options:kNilOptions metrics:nil views:views]];
    [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topMenu]|" options:kNilOptions metrics:nil views:views]];
    [self.topMenuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[sTitle(300)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.topMenuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash1]|" options:kNilOptions metrics:nil views:views]];
    [self.topMenuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[sTitle(150)]-(>=1)-[dash1(0.5)]|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[menuBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash0]|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[menuBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[backBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[backBtn(44)]-(>=1)-[dash0(0.5)]|" options:kNilOptions metrics:nil views:views]];

    self.navTitleOffset = [NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-8.f];
    [self.navBarView addConstraint:self.navTitleOffset];
    [self.navBarView addConstraint:[NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.5f]];
    [self.navBarView addConstraint:[NSLayoutConstraint constraintWithItem:self.backImageButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.menuWrapper addConstraint:[NSLayoutConstraint constraintWithItem:self.topMenuWrapper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:[UIScreen mainScreen].bounds.size.height - 64.5f - 5 * self.menuItemHeight]];
    self.travelTitleConstraint = [NSLayoutConstraint constraintWithItem:self.topMenuWrapper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.menuWrapper attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
    [self.menuWrapper addConstraint:self.travelTitleConstraint];

    self.menuConstraints = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSUInteger i = 0; i <= 4; i++) {
        NLTravelTypeSectionView *sectionView = [[NLTravelTypeSectionView alloc] init];
        sectionView.tag = i;
        [self.menuWrapper addSubview:sectionView];
        [sectionView addTarget:self withAction:@selector(foldMenuAway:)];
        NSDictionary *views = @{ @"section": sectionView };
        NSDictionary *metrics = @{ @"sectionV": [NSNumber numberWithFloat:self.menuItemHeight] };
        [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[section]|" options:kNilOptions metrics:nil views:views]];
        [self.menuWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[section(sectionV)]" options:kNilOptions metrics:metrics views:views]];
        NSLayoutConstraint *sectionConstraint = [NSLayoutConstraint constraintWithItem:self.menuWrapper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sectionView attribute:NSLayoutAttributeBottom multiplier:1.f constant:self.menuItemHeight * (4 - i)];
        [self.menuConstraints addObject:sectionConstraint];
        [self.menuWrapper addConstraint:sectionConstraint];
    }
}

- (void)foldMenuAway:(UIGestureRecognizer *)sender
{
    self.itemToFoldBack = sender.view.tag;

    for (UIView *view in [self.contentWrapper subviews]) {
        [view removeFromSuperview];
    }

    UIView *nextView = nil;
    switch (self.itemToFoldBack) {
        case NLTravelTypeHeli:
        {
            nextView = [[NLTravelHeliView alloc] init];
            break;
        }
        case NLTravelTypeFestival:
        {
            nextView = [[NLTravelFestivalView alloc] init];
            break;
        }
        case NLTravelTypeBus:
        {
            nextView = [[NLTravelBusView alloc] init];
            break;
        }
        case NLTravelTypeTrain:
        {
            nextView = [[NLTravelTrainView alloc] init];
            break;
        }
        case NLTravelTypeCar:
        {
            nextView = [[NLTravelCarView alloc] init];
            self.contentWrapper.delegate = (NLTravelCarView *)nextView;
            break;
        }

        default:
            break;
    }

    if (nextView) {
        [self.contentWrapper addSubview:nextView];
        [self.contentWrapper removeConstraints:[self.contentWrapper constraints]];
        [self.contentWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nextView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(nextView)]];
        [self.contentWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nextView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(nextView)]];
        [self.contentWrapper layoutIfNeeded];
        nextView.transform = CGAffineTransformMakeTranslation(0.f, self.menuWrapper.bounds.size.height - self.menuItemHeight * (4 - self.itemToFoldBack));
    }

    self.travelTitleConstraint.constant = self.travelTitleConstraint.constant - self.menuWrapper.bounds.size.height + self.menuItemHeight * (4 - self.itemToFoldBack);
    for (NSUInteger i = 0; i <= 4; i++) {
        NSLayoutConstraint *constraint = [self.menuConstraints objectAtIndex:i];
        constraint.constant = i > self.itemToFoldBack ? constraint.constant - self.menuWrapper.bounds.size.height : constraint.constant + self.menuWrapper.bounds.size.height - self.menuItemHeight * (4 - self.itemToFoldBack);
    }
    self.navTitleOffset.constant = 17.f;
    [UIView animateWithDuration:0.5f animations:^{
        self.navTitleLabel.transform = CGAffineTransformMakeScale(0.65f, 0.65f);
        self.backImageButton.alpha = 1.f;
        if (nextView) {
            nextView.transform = CGAffineTransformIdentity;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.menuWrapper.hidden = YES;
    }];
}

- (void)foldMenuBack
{
    self.travelTitleConstraint.constant = self.travelTitleConstraint.constant + self.menuWrapper.bounds.size.height - self.menuItemHeight * (4 - self.itemToFoldBack);
    for (NSUInteger i = 0; i <= 4; i++) {
        NSLayoutConstraint *constraint = [self.menuConstraints objectAtIndex:i];
        constraint.constant = i > self.itemToFoldBack ? constraint.constant + self.menuWrapper.bounds.size.height : constraint.constant - self.menuWrapper.bounds.size.height + self.menuItemHeight * (4 - self.itemToFoldBack);
    }
    UIView *nextView = [[self.contentWrapper subviews] firstObject];
    self.navTitleOffset.constant = -8.f;
    self.menuWrapper.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.navTitleLabel.transform = CGAffineTransformIdentity;
        self.backImageButton.alpha = 0.f;
        if (nextView) {
            CGRect frame = nextView.frame;
            frame.origin.y = self.menuWrapper.bounds.size.height - self.menuItemHeight * (4 - self.itemToFoldBack);
            nextView.frame = frame;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.contentWrapper.delegate = nil;
    }];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
