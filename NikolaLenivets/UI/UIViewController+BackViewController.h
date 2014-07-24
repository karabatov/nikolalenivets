//
//  UIViewController+BackViewController.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 22.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

@interface UIViewController (BackViewController)

/**
 Get previous view controller in the navigation controller stack.
 
 @return Previous view controller or nil.
 */
- (UIViewController *)backViewController;

@end
