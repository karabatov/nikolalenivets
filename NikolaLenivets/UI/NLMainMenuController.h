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

@property (strong, nonatomic) UILabel *newsCounter;
@property (strong, nonatomic) UILabel *eventsCounter;
@property (strong, nonatomic) UILabel *mapCounter;
@property (strong, nonatomic) UILabel *placesCounter;

@end
