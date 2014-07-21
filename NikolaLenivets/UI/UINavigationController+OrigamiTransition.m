//
//  UINavigationController+OrigamiTransition.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 21.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "UINavigationController+OrigamiTransition.h"

@implementation UINavigationController (OrigamiTransition)


- (void)pushOrigamiViewController:(UIViewController *)destinationController animated:(BOOL)animated
{
    UIViewController *sourceViewController = self.topViewController;

    [sourceViewController.view showOrigamiTransitionWith:destinationController.view
                                           NumberOfFolds:1
                                                Duration:0.7f
                                               Direction:XYOrigamiDirectionFromRight
                                              completion:^(BOOL finished) {

                                                  NSLog(@"Transition completed.");
                                                  [self pushViewController:destinationController animated:NO];

                                              }];
}

- (void)popOrigamiViewController
{
    UIViewController *sourceViewController = self.topViewController;
    NSInteger indexOfBackController = [self.viewControllers count] - 2;

    [((UIViewController *)(self.viewControllers[indexOfBackController])).view hideOrigamiTransitionWith:sourceViewController.view
                                           NumberOfFolds:1
                                                Duration:0.7f
                                               Direction:XYOrigamiDirectionFromRight
                                              completion:^(BOOL finished) {

                                                  NSLog(@"Transition completed.");
                                                  [self popViewControllerAnimated:NO];
                                                  
                                              }];
}


@end
