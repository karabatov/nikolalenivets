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
    __strong PaperFoldView *_paperFoldView;
    __strong NLItemsListController *_newsList;
    __strong NLEventGroupsViewController *_eventsController;
    __strong NLPlacesViewController *_placesController;
    __strong UIView *_contentView;
    __strong NLStaticScreenViewController *_driveScreen;
}


- (id)init
{
    self = [super initWithNibName:@"NLMainMenuController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuState) name:STORAGE_DID_UPDATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:SHOW_MENU_NOW object:nil];
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

    CGRect frame = [[UIScreen mainScreen] bounds];

    _contentView = [[UIView alloc] initWithFrame:frame];
    _paperFoldView = [[PaperFoldView alloc] initWithFrame:frame];
    _paperFoldView.delegate = self;

    [self.view addSubview:_paperFoldView];
    [_paperFoldView setLeftFoldContentView:self.menuView foldCount:1 pullFactor:0.9];
    [_paperFoldView setCenterContentView:_contentView];
    _paperFoldView.enableLeftFoldDragging = NO;
    [self showMenu];
}


- (void)showMenu
{
    [_paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded];
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
        default:
            //[_contentView addSubview:self.childView];
            return;
            break;
    }
    
    [_paperFoldView setPaperFoldState:PaperFoldStateDefault];
    //[SKUTouchPresenter showTouchesWithColor:nil];
}


- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState
{
//    if (paperFoldState == PaperFoldStateLeftUnfolded) {
//        [SKUTouchPresenter showTouchesWithColor:[UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:0.2]];
//    }
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

@end
