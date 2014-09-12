//
//  NLMainMenuController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMainMenuController.h"
#import "NLItemsListController.h"
#import "NLEventGroupsViewController.h"
#import "NLPlacesViewController.h"
#import "NLStaticScreenViewController.h"
#import "NLMapViewController.h"
#import "NSAttributedString+Kerning.h"
#import "NLFoldAnimation.h"
#import "NLMenuButton.h"
#import "NLLocationManager.h"
#import "NLSearchViewController.h"

#define FOLD_DURATION 0.7

enum {
    News   = 0,
    Events = 1,
    Map    = 2,
    Places = 3,
    Way    = 4,
    About  = 5,
    Search = 6
};


@implementation NLMainMenuController
{
    NLItemsListController *_newsList;
    NLEventGroupsViewController *_eventsController;
    NLPlacesViewController *_placesController;
    NLStaticScreenViewController *_driveScreen;
    NLMapViewController *_mapController;
    NLSearchViewController *_searchController;
    NLMenuButton *_newsButton;
    NLMenuButton *_eventsButton;
    NLMenuButton *_mapButton;
    NLMenuButton *_placesButton;
    NLMenuButton *_directionsButton;
    NLMenuButton *_aboutButton;
    UIView *_splashView;
    UIView *_blackTopBar;
    UIImageView *_splashTopBar;
    UIImageView *_splashBgImage;
    UILabel *_nikolaLabel;
    UILabel *_lenivetsLabel;
    UIView *_menuView;
    NSLayoutConstraint *_blackBarWidth;
    UIImageView *_compass;
    UIButton *_searchButton;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuState) name:STORAGE_DID_UPDATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingUpdated:) name:NLUserHeadingUpdated object:nil];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    _splashView = [[UIView alloc] init];
    [_splashView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_splashView setBackgroundColor:[UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1.f]];

    _menuView = [[UIView alloc] init];
    [_menuView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_menuView setBackgroundColor:[UIColor clearColor]];
    _menuView.alpha = 0.f;

    [self.view addSubview:_splashView];
    [self.view addSubview:_menuView];

    _splashBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    [_splashBgImage setTranslatesAutoresizingMaskIntoConstraints:NO];

    _splashTopBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash-top.png"]];
    [_splashTopBar setTranslatesAutoresizingMaskIntoConstraints:NO];

    _blackTopBar = [[UIView alloc] init];
    [_blackTopBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_blackTopBar setBackgroundColor:[UIColor blackColor]];

    _nikolaLabel = [[UILabel alloc] init];
    [_nikolaLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _nikolaLabel.attributedText = [NSAttributedString kernedStringForString:@"НИКОЛА" withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];
    [_nikolaLabel setBackgroundColor:[UIColor clearColor]];

    _lenivetsLabel = [[UILabel alloc] init];
    [_lenivetsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _lenivetsLabel.attributedText = [NSAttributedString kernedStringForString:@"ЛЕНИВЕЦ" withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];
    [_lenivetsLabel setBackgroundColor:[UIColor clearColor]];

    _compass = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass-white.png"]];
    [_compass setTranslatesAutoresizingMaskIntoConstraints:NO];

    [_splashView addSubview:_splashBgImage];
    [_splashView addSubview:_splashTopBar];
    [_splashView addSubview:_blackTopBar];
    [_splashView addSubview:_nikolaLabel];
    [_splashView addSubview:_lenivetsLabel];
    [_splashView addSubview:_compass];

    _newsButton = [[NLMenuButton alloc] init];
    _eventsButton = [[NLMenuButton alloc] init];
    _mapButton = [[NLMenuButton alloc] init];
    _placesButton = [[NLMenuButton alloc] init];
    _directionsButton = [[NLMenuButton alloc] init];
    _aboutButton = [[NLMenuButton alloc] init];

    [_menuView addSubview:_newsButton];
    [_menuView addSubview:_eventsButton];
    [_menuView addSubview:_mapButton];
    [_menuView addSubview:_placesButton];
    [_menuView addSubview:_directionsButton];
    [_menuView addSubview:_aboutButton];

    _newsButton.tag = News;
    _eventsButton.tag = Events;
    _mapButton.tag = Map;
    _placesButton.tag = Places;
    _directionsButton.tag = Way;
    _aboutButton.tag = About;

    _newsButton.title = @"НОВОСТИ";
    _eventsButton.title = @"СОБЫТИЯ";
    _mapButton.title = @"КАРТА";
    _placesButton.title = @"МЕСТА";
    _directionsButton.title = @"ДОБРАТЬСЯ";
    _aboutButton.title = @"О ПАРКЕ";

    self.newsCounter = [[UILabel alloc] init];
    self.eventsCounter = [[UILabel alloc] init];
    self.mapCounter = [[UILabel alloc] init];
    self.placesCounter = [[UILabel alloc] init];
    [self.newsCounter setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mapCounter setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.eventsCounter setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placesCounter setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_menuView addSubview:self.newsCounter];
    [_menuView addSubview:self.eventsCounter];
    [_menuView addSubview:self.mapCounter];
    [_menuView addSubview:self.placesCounter];

    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_searchButton setImage:[UIImage imageNamed:@"search-normal.png"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"search-selected.png"] forState:UIControlStateHighlighted];
    _searchButton.tag = Search;
    [_searchButton addTarget:self action:@selector(unfoldItem:) forControlEvents:UIControlEventTouchUpInside];

    [_menuView addSubview:_searchButton];

    self.newsCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.mapCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.eventsCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    [self.eventsCounter setTextAlignment:NSTextAlignmentRight];
    self.placesCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    [self.placesCounter setTextAlignment:NSTextAlignmentRight];

    _newsButton.counter = self.newsCounter;
    _eventsButton.counter = self.eventsCounter;
    _mapButton.counter = self.mapCounter;
    _placesButton.counter = self.placesCounter;

    for (UIView *view in [_menuView subviews]) {
        if ([view isKindOfClass:[NLMenuButton class]]) {
            [(NLMenuButton *)view addTarget:self action:@selector(unfoldItem:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    NSDictionary *views = @{ @"splash": _splashView,
                             @"menu": _menuView,
                             @"splashBg": _splashBgImage,
                             @"splashTop": _splashTopBar,
                             @"blackTopBar": _blackTopBar,
                             @"nikola": _nikolaLabel,
                             @"lenivets": _lenivetsLabel,
                             @"compass": _compass,
                             @"news": _newsButton,
                             @"events": _eventsButton,
                             @"map": _mapButton,
                             @"places": _placesButton,
                             @"way": _directionsButton,
                             @"about": _aboutButton,
                             @"cntNews": self.newsCounter,
                             @"cntEvents": self.eventsCounter,
                             @"cntMap": self.mapCounter,
                             @"cntPlaces": self.placesCounter,
                             @"searchB": _searchButton };
    CGFloat buttonSize = roundf((([UIScreen mainScreen].bounds.size.height - 161.f) / 3) * 2.f) / 2.f; // Round to 0.5
    NSDictionary *metrics = @{ @"csbtnS": @62, @"bgIV": @568, @"splTopV": @4, @"blackBarV": @3.5, @"btnTop": @81, @"btnH": @122, @"btnV": [NSNumber numberWithFloat:buttonSize], @"btnMargin": @17 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menu]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splash]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menu]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splash]|" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splashTop]|" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splashBg]|" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splashBg(bgIV)]" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nikola]-(-1.5)-[blackTopBar]-(-0.5)-[lenivets]" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splashTop(splTopV)]" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blackTopBar(blackBarV)]" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[compass(csbtnS)]" options:kNilOptions metrics:metrics views:views]];
    [_splashView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[compass(csbtnS)]" options:kNilOptions metrics:metrics views:views]];
    _blackBarWidth = [NSLayoutConstraint constraintWithItem:_blackTopBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:[UIScreen mainScreen].bounds.size.width];
    [_splashView addConstraint:_blackBarWidth];
    [_splashView addConstraint:[NSLayoutConstraint constraintWithItem:_blackTopBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_splashView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [_splashView addConstraint:[NSLayoutConstraint constraintWithItem:_nikolaLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_blackTopBar attribute:NSLayoutAttributeTop multiplier:1.f constant:13.5f]];
    [_splashView addConstraint:[NSLayoutConstraint constraintWithItem:_lenivetsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_blackTopBar attribute:NSLayoutAttributeTop multiplier:1.f constant:13.5f]];
    [_splashView addConstraint:[NSLayoutConstraint constraintWithItem:_compass attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_splashView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [_splashView addConstraint:[NSLayoutConstraint constraintWithItem:_compass attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_splashView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-48.f]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[news(btnH)][cntNews]-(>=0)-[cntEvents][events(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[map(btnH)][cntMap]-(>=0)-[cntPlaces][places(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[way(btnH)]-(>=0)-[about(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnTop-[news(btnV)][map(btnV)][way(btnV)]-(>=0)-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnTop-[events(btnV)][places(btnV)][about(btnV)]-(>=0)-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_newsButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.5f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.mapCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mapButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.5f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventsCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_eventsButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.5f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.placesCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_placesButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.5f]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[searchB(csbtnS)]" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchB(csbtnS)]" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:_searchButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_menuView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:_searchButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_menuView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-48.f]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMenuState];
}


- (void)viewDidAppear:(BOOL)animated
{
    static BOOL firstTime = YES;

    if (firstTime) {
        firstTime = NO;
        srand48(time(0));
        CGFloat anim1 = drand48() * 2;
        CGFloat anim2 = drand48() * 5;
        CGFloat anim3 = drand48() * 2;

        _blackBarWidth.constant = 160;
        [UIView animateWithDuration:anim1 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _blackBarWidth.constant = 128;
            [UIView animateWithDuration:anim2 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                _blackBarWidth.constant = 63.5;
                [UIView animateWithDuration:anim3 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [self performSelector:@selector(dismissSplash) withObject:nil afterDelay:3];
                }];
            }];
        }];
    }
}


#pragma mark - Paper Fold Stuff

- (void)unfoldItem:(NLMenuButton *)sender
{
    switch (sender.tag) {
        case News: {
            _newsList = [NLItemsListController new];
            self.title = @"НОВОСТИ";
            [self.navigationController pushViewController:_newsList animated:YES];
            break;
        }
        case Events: {
            _eventsController = [NLEventGroupsViewController new];
            self.title = @"СОБЫТИЯ";
            [self.navigationController pushViewController:_eventsController animated:YES];
            break;
        }
        case Places: {
            _placesController = [NLPlacesViewController new];
            self.title = @"МЕСТА";
            [self.navigationController pushViewController:_placesController animated:YES];
            break;
        }
        case Way: {
            _driveScreen = [[NLStaticScreenViewController alloc] initWithScreenNamed:@"drive"];
            self.title = @"ДОБРАТЬСЯ";
            [self.navigationController pushViewController:_driveScreen animated:YES];
            break;
        }
        case Map: {
            _mapController = [NLMapViewController new];
            self.title = @"КАРТА";
            [self.navigationController pushViewController:_mapController animated:YES];
            break;
        }
        case About:
            _driveScreen = [[NLStaticScreenViewController alloc] initWithScreenNamed:@"about"];
            self.title = @"О ПАРКЕ";
            [self.navigationController pushViewController:_driveScreen animated:YES];
            break;
        case Search:
            _searchController = [[NLSearchViewController alloc] init];
            self.title = @"ПОИСК";
            [self.navigationController pushViewController:_searchController animated:YES];
            break;
        default:
            return;
            break;
    }
}


#pragma mark - actions

- (void)updateMenuState
{
    // TODO: Quick running count animation
    NLStorage *store = [NLStorage sharedInstance];
    self.newsCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)[store unreadCountInArray:store.news]];
    self.eventsCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)[store unreadCountInArray:store.eventGroups]];
    self.mapCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)[store unreadCountInArray:store.places]];
    self.placesCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)[store unreadCountInArray:store.places]];
}


- (void)headingUpdated:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _compass.transform = [[NLLocationManager sharedInstance] compassTransform];
    } completion:NULL];
}

- (void)dismissSplash
{
    UIColor *newGray = [UIColor colorWithRed:126.f/255.f green:126.f/255.f blue:126.f/255.f alpha:1.f];
    [UIView animateWithDuration:0.75f animations:^{
        _splashTopBar.alpha = 0.7f;
        _splashBgImage.alpha = 0.f;
        _compass.alpha = 0.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            _splashTopBar.alpha = 0.0f;
            _nikolaLabel.attributedText = [NSAttributedString kernedStringForString:_nikolaLabel.text withFontSize:18 kerning:2.2f andColor:newGray];
            _lenivetsLabel.attributedText = [NSAttributedString kernedStringForString:_lenivetsLabel.text withFontSize:18 kerning:2.2f andColor:newGray];
            _menuView.alpha = 1.f;
        } completion:^(BOOL finished) {
            [_splashTopBar removeFromSuperview];
            _splashTopBar = nil;
            [_splashBgImage removeFromSuperview];
            _splashBgImage = nil;
        }];
    }];
}


#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[NLSearchViewController class]] && [fromVC isKindOfClass:[NLMainMenuController class]]) {
        NLFoldAnimation *animationController = [[NLFoldAnimation alloc] init];
        animationController.direction = XYOrigamiDirectionFromTop;
        animationController.folds = 6;
        animationController.duration = 10;
        animationController.offset = ceilf(-1.f * [UIScreen mainScreen].bounds.size.height / (CGFloat)animationController.folds / 2.f);
        return animationController;
    }
    if ([fromVC isKindOfClass:[NLSearchViewController class]] && [toVC isKindOfClass:[NLMainMenuController class]]) {
        NLFoldAnimation *animationController = [[NLFoldAnimation alloc] init];
        animationController.direction = XYOrigamiDirectionFromTop;
        animationController.reverse = YES;
        animationController.folds = 6;
        animationController.duration = 10;
        animationController.offset = ceilf(-1.f * [UIScreen mainScreen].bounds.size.height / (CGFloat)animationController.folds / 2.f);
        return animationController;
    }
    if ([fromVC isKindOfClass:[NLMapViewController class]] || [toVC isKindOfClass:[NLMapViewController class]]) {
        NLFoldAnimation *animationController = [[NLFoldAnimation alloc] init];
        animationController.folds = 3;
        animationController.duration = 1.4;
        switch (operation) {
            case UINavigationControllerOperationPush:
                animationController.direction = XYOrigamiDirectionFromRight;
                animationController.reverse = YES;
                return animationController;
            case UINavigationControllerOperationPop:
                animationController.direction = XYOrigamiDirectionFromRight;
                animationController.reverse = NO;
                return animationController;
            default:
                return nil;
        }
    } else if ([toVC isKindOfClass:[NLMainMenuController class]] || [fromVC isKindOfClass:[NLMainMenuController class]]) {
        NLFoldAnimation *animationController = [[NLFoldAnimation alloc] init];
        switch (operation) {
            case UINavigationControllerOperationPush:
                animationController.reverse = NO;
                return animationController;
            case UINavigationControllerOperationPop:
                animationController.reverse = YES;
                return animationController;
            default:
                return nil;
        }
    } else {
        return nil;
    }
}

@end
