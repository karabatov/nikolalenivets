//
//  UINavigationController+OrigamiTransition.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 21.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "UIView+Origami.h"

@interface UINavigationController (OrigamiTransition)

- (void)pushOrigamiViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popOrigamiViewController;

@end
