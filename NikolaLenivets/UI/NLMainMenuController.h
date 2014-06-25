//
//  NLMainMenuController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLStorage.h"
#import "UIView+Origami.h"

#define SHOW_MENU_NOW @"SHOW_MENU_NOW"

@interface NLMainMenuController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

/* Fancy stuff */
@property (weak, nonatomic) IBOutlet UILabel *nikolaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenivetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UILabel *newsCounter;
@property (weak, nonatomic) IBOutlet UILabel *eventsCounter;
@property (weak, nonatomic) IBOutlet UILabel *mapCounter;
@property (weak, nonatomic) IBOutlet UILabel *placesCounter;

@end
