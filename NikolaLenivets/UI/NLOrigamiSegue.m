//
//  NLOrigamiSegue.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 21.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLOrigamiSegue.h"
#import "UIView+Origami.h"

@implementation NLOrigamiSegue


- (void)perform
{
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];

    [sourceViewController.view showOrigamiTransitionWith:destinationController.view
                                           NumberOfFolds:1
                                                Duration:0.7f
                                               Direction:XYOrigamiDirectionFromRight
                                              completion:^(BOOL finished) {

                                                  NSLog(@"Transition completed.");
                                                  [sourceViewController presentViewController:destinationController animated:NO completion:nil];
                                                  
                                              }];
    
}


@end
