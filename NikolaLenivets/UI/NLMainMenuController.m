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

#define FOLD_DURATION 0.7

enum {
    News   = 0,
    Events = 1,
    Map    = 2,
    Places = 3,
    Way    = 4,
    About  = 5
};


@implementation NLMainMenuController
{
    NLItemsListController *_newsList;
    NLEventGroupsViewController *_eventsController;
    NLPlacesViewController *_placesController;
    NLStaticScreenViewController *_driveScreen;
    NLMapViewController *_mapController;
    NLMenuButton *_newsButton;
    NLMenuButton *_eventsButton;
    NLMenuButton *_mapButton;
    NLMenuButton *_placesButton;
    NLMenuButton *_directionsButton;
    NLMenuButton *_aboutButton;
    UIView *_splashView;
    UIView *_blackTopBar;
    UILabel *_nikolaLabel;
    UILabel *_lenivetsLabel;
    UIView *_menuView;
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
                             @"news": _newsButton,
                             @"events": _eventsButton,
                             @"map": _mapButton,
                             @"places": _placesButton,
                             @"way": _directionsButton,
                             @"about": _aboutButton,
                             @"cntNews": self.newsCounter,
                             @"cntEvents": self.eventsCounter,
                             @"cntMap": self.mapCounter,
                             @"cntPlaces": self.placesCounter };
    NSDictionary *metrics = @{ @"btnTop": @81, @"btnH": @122, @"btnV": @135, @"btnV2": @136, @"btnMargin": @17 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menu]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splash]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menu]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splash]|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[news(btnH)][cntNews]-(>=0)-[cntEvents][events(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[map(btnH)][cntMap]-(>=0)-[cntPlaces][places(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[way(btnH)]-(>=0)-[about(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnTop-[news(btnV)][map(btnV2)][way(btnV)]-(>=btnMargin)-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnTop-[events(btnV)][places(btnV2)][about(btnV)]-(>=btnMargin)-|" options:kNilOptions metrics:metrics views:views]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_newsButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.mapCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mapButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventsCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_eventsButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.f]];
    [_menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.placesCounter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_placesButton attribute:NSLayoutAttributeTop multiplier:1.f constant:8.f]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMenuState];
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
//    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        [self.compass layer].transform = [[NLLocationManager sharedInstance] compassTransform3D];
//    } completion:NULL];
}


#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[NLMainMenuController class]] || [fromVC isKindOfClass:[NLMainMenuController class]] ||
        [toVC isKindOfClass:[NLMapViewController class]]  || [fromVC isKindOfClass:[NLMapViewController class]]) {
        NLFoldAnimation *animationController = [[NLFoldAnimation alloc] init];
        switch (operation) {
            case UINavigationControllerOperationPush:
                animationController.reverse = YES;
                return animationController;
            case UINavigationControllerOperationPop:
                animationController.reverse = NO;
                return animationController;
            default:
                return nil;
        }
    } else {
        return nil;
    }
}

@end
