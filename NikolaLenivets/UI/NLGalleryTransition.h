//
//  NLGalleryTransition.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 07.08.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "NLGalleryViewController.h"
#import "NLDetailsViewController.h"

/**
 Used to interactively transition from a detail view to a full-screen gallery view.
 */
@interface NLGalleryTransition : UIPercentDrivenInteractiveTransition

/**
 View controller to return to.
 */
@property (nonatomic, readonly) NLDetailsViewController *parentViewController;

/**
 Gallery view controller.
 */
@property (nonatomic, readonly) NLGalleryViewController *galleryViewController;

/**
 Returns `NLGalleryTransition` with its parent view controller set.
 
 @param viewController Parent view controller.
 @return Initialized `NLGalleryTransition`.
 */
- (instancetype)initWithParentViewController:(UIViewController *)viewController andGalleryController:(UIViewController *)galleryVC;

/**
 Show gallery non-interactively.
 */
- (void)presentGallery;

/**
 Show gallery interactively.
 */
- (void)userDidPan:(UIPanGestureRecognizer *)recognizer;

@end
