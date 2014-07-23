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
}


- (id)init
{
    self = [super initWithNibName:@"NLMainMenuController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuState) name:STORAGE_DID_UPDATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:SHOW_MENU_NOW object:nil];
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

    // Need to set fonts *before* the view is displayed
    self.nikolaLabel.attributedText = [NSAttributedString kernedStringForString:@"НИКОЛА"];
    self.lenivetsLabel.attributedText = [NSAttributedString kernedStringForString:@"ЛЕНИВЕЦ"];
    self.newsCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.mapCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.eventsCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.placesCounter.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];

    for (UIView *v in self.menuView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            btn.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:16];
        }
    }

    [self showMenu];
}


- (void)showMenu
{
    [self updateMenuState];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"menu view will appear");
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"menu view did appear");
    [super viewDidAppear:animated];
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
            self.title = @"КАК ДОБРАТЬСЯ";
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
    self.compass.transform = [[NLLocationManager sharedInstance] compassTransform];
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
                return  animationController;
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
