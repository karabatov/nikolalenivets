//
//  UIViewController+BackViewController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 22.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "UIViewController+BackViewController.h"

@implementation UIViewController (BackViewController)


- (UIViewController *)backViewController
{
    NSInteger myIndex = [self.navigationController.viewControllers indexOfObject:self];

    if ( myIndex != 0 && myIndex != NSNotFound ) {
        return [self.navigationController.viewControllers objectAtIndex:myIndex - 1];
    } else {
        return nil;
    }
}


@end
