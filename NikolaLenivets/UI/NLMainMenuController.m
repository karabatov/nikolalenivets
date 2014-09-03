//
//  NLMainMenuController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMainMenuController.h"
#import "SKUTouchPresenter.h"
#import "NLItemsListController.h"
#import "NLEventGroupsViewController.h"
#import "NLPlacesViewController.h"
#import "NLStaticScreenViewController.h"
#import "NLMapViewController.h"
#import "NSAttributedString+Kerning.h"
#import "NLFoldAnimation.h"
#import "NLSplashViewController.h"
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
}


- (instancetype)init
{
    self = [super initWithNibName:@"NLMainMenuController" bundle:nil];
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

    _newsButton = [[NLMenuButton alloc] init];
    _eventsButton = [[NLMenuButton alloc] init];
    _mapButton = [[NLMenuButton alloc] init];
    _placesButton = [[NLMenuButton alloc] init];
    _directionsButton = [[NLMenuButton alloc] init];
    _aboutButton = [[NLMenuButton alloc] init];

    [self.menuView addSubview:_newsButton];
    [self.menuView addSubview:_eventsButton];
    [self.menuView addSubview:_mapButton];
    [self.menuView addSubview:_placesButton];
    [self.menuView addSubview:_directionsButton];
    [self.menuView addSubview:_aboutButton];

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

    // Need to set fonts *before* the view is displayed
    self.nikolaLabel.attributedText = [NSAttributedString kernedStringForString:@"НИКОЛА"];
    self.lenivetsLabel.attributedText = [NSAttributedString kernedStringForString:@"ЛЕНИВЕЦ"];
    self.newsCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
    self.mapCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
    self.eventsCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
    self.placesCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];

    NSDictionary *views = @{ @"news": _newsButton, @"events": _eventsButton, @"map": _mapButton, @"places": _placesButton, @"way": _directionsButton, @"about": _aboutButton };
    NSDictionary *metrics = @{ @"btnTop": @81, @"btnH": @121, @"btnV": @135, @"btnMargin": @17 };
    [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[news(btnH)]-(>=btnMargin)-[events(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[map(btnH)]-(>=btnMargin)-[places(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[way(btnH)]-(>=btnMargin)-[about(btnH)]-btnMargin-|" options:kNilOptions metrics:metrics views:views]];
    [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnTop-[news(btnV)][map(btnV)][way(btnV)]-(>=btnMargin)-|" options:kNilOptions metrics:metrics views:views]];
    [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnTop-[events(btnV)][places(btnV)][about(btnV)]-(>=btnMargin)-|" options:kNilOptions metrics:metrics views:views]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMenuState];
}


#pragma mark - Paper Fold Stuff

- (IBAction)unfoldItem:(UIButton *)sender
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
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.compass layer].transform = [[NLLocationManager sharedInstance] compassTransform3D];
    } completion:NULL];
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
        if ([fromVC isKindOfClass:[NLSplashViewController class]]) {
            animationController.reverse = YES;
            return animationController;
        }
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
