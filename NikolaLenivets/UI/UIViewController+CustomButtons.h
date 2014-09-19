//
//  UIViewController+CustomButtons.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 19.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "NLNavigationBar.h"

/**
 Custom buttons and init for navigation bar.
 */
@interface UIViewController (CustomButtons)

- (void)setupForNavBarWithStyle:(NLNavigationBarStyle)style;
- (void)customButtons_popViewController;
- (void)customButtons_popToRootViewController;

@end
