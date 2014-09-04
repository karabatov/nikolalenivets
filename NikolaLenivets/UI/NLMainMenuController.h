//
//  NLMainMenuController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "NLStorage.h"

@interface NLMainMenuController : UIViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *menuView;

/* Fancy stuff */
@property (weak, nonatomic) IBOutlet UILabel *nikolaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenivetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) UILabel *newsCounter;
@property (strong, nonatomic) UILabel *eventsCounter;
@property (strong, nonatomic) UILabel *mapCounter;
@property (strong, nonatomic) UILabel *placesCounter;
@property (weak, nonatomic) IBOutlet UIImageView *compass;

@end
