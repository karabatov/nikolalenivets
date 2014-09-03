//
//  NLGalleryTransition.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 07.08.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLGalleryTransition.h"

@interface NLGalleryTransition () <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation NLGalleryTransition

#pragma mark - Public methods

- (instancetype)initWithParentViewController:(UIViewController *)viewController andGalleryController:(UIViewController *)galleryVC
{
    if (!(self = [super init])) return nil;

    _parentViewController = (NLDetailsViewController *)viewController;
    _galleryViewController = (NLGalleryViewController *)galleryVC;

    return self;
}

- (void)userDidPan:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"userDidPan:");
    
    CGPoint location = [recognizer locationInView:self.parentViewController.view];
    CGPoint velocity = [recognizer velocityInView:self.parentViewController.view];

    // Note: Only one presentation may occur at a time, as per usual

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // We're being invoked via a gesture recognizer – we are necessarily interactive
        self.interactive = YES;

        if (location.x < CGRectGetMidX(recognizer.view.bounds)) {
            self.presenting = YES;
            self.galleryViewController.modalPresentationStyle = UIModalPresentationCustom;
            self.galleryViewController.transitioningDelegate = self;
            [self.parentViewController.navigationController pushViewController:self.galleryViewController animated:YES];
        }
        else {
            [self.parentViewController.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // CGFloat ratio = location.x / CGRectGetWidth(self.parentViewController.view.bounds);
        // [self updateInteractiveTransition:ratio];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Depending on our state and the velocity, determine whether to cancel or complete the transition.
        if (self.presenting) {
            if (velocity.x > 0) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
        }
        else {
            if (velocity.x < 0) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
        }
    }
}

- (void)presentGallery
{
    [self.parentViewController showGallery:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }

    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }

    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animationEnded:(BOOL)transitionCompleted
{
    // Reset to our default state
    self.interactive = NO;
    self.presenting = NO;
    self.transitionContext = nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Used only in non-interactive transitions, despite the documentation
    return 0.7f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.interactive) {
        // nop as per documentation
    }
    else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        if (self.presenting) {
            // The order of these matters – determines the view hierarchy order.
            [transitionContext.containerView addSubview:fromViewController.view];
            [transitionContext.containerView addSubview:toViewController.view];

            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                //
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        else {
            [transitionContext.containerView addSubview:toViewController.view];
            [transitionContext.containerView addSubview:fromViewController.view];

            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                //
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.presenting)
    {
        // The order of these matters – determines the view hierarchy order.
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
    }
    else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
    }
}

#pragma mark - UIPercentDrivenInteractiveTransition

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    // id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;

    // UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // Presenting goes from 0...1 and dismissing goes from 1...0
    // CGRect frame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]) * (1.0f - percentComplete), 0);

    if (self.presenting)
    {
        // toViewController.view.frame = frame;
    }
    else {
        // fromViewController.view.frame = frame;
    }
}

- (void)finishInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;

    // UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.presenting)
    {
        [UIView animateWithDuration:0.5f animations:^{
            //
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            //
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }

}

- (void)cancelInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;

    // UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.presenting)
    {
        [UIView animateWithDuration:0.5f animations:^{
            //
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            //
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
}


@end
