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
    [self showMenu];
}


- (void)showMenu
{
    [self.contentView showOrigamiTransitionWith:self.menuView
                           NumberOfFolds:1
                                Duration:0.3
                               Direction:XYOrigamiDirectionFromLeft
                              completion:^(BOOL finished) {
                                  NSLog(@"Finished animation");
                              }];
    [self updateMenuState];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nikolaLabel.font = [UIFont fontWithName:@"MonoCondensedCBold" size:16];
    self.lenivetsLabel.font = [UIFont fontWithName:@"MonoCondensedCBold" size:16];
    
    for (UIView *v in self.menuView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            btn.titleLabel.font = [UIFont fontWithName:@"MonoCondensedCBold" size:16];
        }
    }
}


#pragma mark - Paper Fold Stuff

- (IBAction)unfoldItem:(UIButton *)sender
{
    for (UIView *v in _contentView.subviews) {
        [v removeFromSuperview];
    }

    switch (sender.tag) {
        case News: {
            _newsList = [NLItemsListController new];
            [_contentView addSubview:_newsList.view];
            break;
        }
        case Events: {
            _eventsController = [NLEventGroupsViewController new];
            [_contentView addSubview:_eventsController.view];
            break;
        }
        case Places: {
            _placesController = [NLPlacesViewController new];
            [_contentView addSubview:_placesController.view];
            break;
        }
        case Way: {
            _driveScreen = [[NLStaticScreenViewController alloc] initWithScreenNamed:@"drive"];
            [_contentView addSubview:_driveScreen.view];
            break;
        }
        case Map:
            _mapController = [NLMapViewController new];
            [_contentView addSubview:_mapController.view];
            break;
        case About:
            _driveScreen = [[NLStaticScreenViewController alloc] initWithScreenNamed:@"about"];
            [_contentView addSubview:_driveScreen.view];
            break;
        default:
            return;
            break;
    }

    [self.contentView hideOrigamiTransitionWith:self.menuView
                           NumberOfFolds:1
                                Duration:0.3
                               Direction:XYOrigamiDirectionFromLeft
                              completion:^(BOOL finished) {
                                  NSLog(@"Finished transition");
                              }];
}


#pragma mark - actions

- (void)updateMenuState
{
    NLStorage *store = [NLStorage sharedInstance];
    self.newsCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)store.news.count];
    self.eventsCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)store.eventGroups.count];
    self.mapCounter.text = @"00";
    self.placesCounter.text = [NSString stringWithFormat:@"%02lu", (unsigned long)store.places.count];
}


- (void)headingUpdated:(NSNotification *)notification
{
    self.compass.transform = [[NLLocationManager sharedInstance] compassTransform];;
}

@end
