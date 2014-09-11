//
//  NLFoldAnimation.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLFoldAnimation.h"

#define radians( degrees ) ( ( degrees ) / 180.0 * M_PI )

KeyframeParametricBlock openFunction = ^double(double time) {
    return sin(time * M_PI_2);
};
KeyframeParametricBlock closeFunction = ^double(double time) {
    return -cos(time * M_PI_2) + 1;
};

@implementation CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path function:(KeyframeParametricBlock)block fromValue:(double)fromValue toValue:(double)toValue
{
    // get a keyframe animation to set up
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
    // break the time into steps (the more steps, the smoother the animation)
    NSUInteger steps = 100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    double time = 0.0;
    double timeStep = 1.0 / (double)(steps - 1);
    for(NSUInteger i = 0; i < steps; i++) {
        double value = fromValue + (block(time) * (toValue - fromValue));
        [values addObject:[NSNumber numberWithDouble:value]];
        time += timeStep;
    }
    // we want linear animation between keyframes, with equal time steps
    animation.calculationMode = kCAAnimationLinear;
    // set keyframes and we're done
    [animation setValues:values];
    return(animation);
}

@end


@implementation NLFoldAnimation


- (id)init {
    if (self = [super init]) {
        self.folds = 1;
        self.direction = XYOrigamiDirectionFromLeft;
        self.duration = 0.7f;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;

    [containerView addSubview:toView];

    if (self.reverse) {
        [containerView bringSubviewToFront:fromView];
        //set frame
        CGRect selfFrame = fromView.frame;
        CGPoint anchorPoint;
        if (self.direction == XYOrigamiDirectionFromRight) {
            selfFrame.origin.x = fromView.frame.origin.x - toView.bounds.size.width;
            toView.frame = CGRectMake(fromView.frame.origin.x + fromView.frame.size.width - toView.frame.size.width, fromView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            anchorPoint = CGPointMake(1, 0.5);
        } else if (self.direction == XYOrigamiDirectionFromLeft){
            selfFrame.origin.x = fromView.frame.origin.x + toView.bounds.size.width;
            toView.frame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            anchorPoint = CGPointMake(0, 0.5);
        } else if (self.direction == XYOrigamiDirectionFromTop) {
            selfFrame.origin.y = fromView.frame.origin.y + toView.bounds.size.height;
            toView.frame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            anchorPoint = CGPointMake(0.5, 0);
        } else if (self.direction == XYOrigamiDirectionFromBottom) {
            selfFrame.origin.y = fromView.frame.origin.y - toView.bounds.size.height;
            toView.frame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y + fromView.frame.size.height - toView.frame.size.height, toView.frame.size.width, toView.frame.size.height);
            anchorPoint = CGPointMake(0.5, 1);
        }

        UIGraphicsBeginImageContext(toView.frame.size);
        [toView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        //set 3D depth
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.0/800.0;
        CALayer *origamiLayer = [CALayer layer];
        origamiLayer.frame = toView.bounds;
        origamiLayer.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
        origamiLayer.sublayerTransform = transform;
        [toView.layer addSublayer:origamiLayer];

        //setup rotation angle
        double startAngle;
        CGFloat frameWidth = toView.bounds.size.width;
        CGFloat frameHeight = toView.bounds.size.height;
        CGFloat foldWidth = (self.direction < 2) ? frameWidth / (self.folds * 2) : frameHeight / (self.folds * 2);
        CALayer *prevLayer = origamiLayer;
        for (int b = 0; b < self.folds * 2; b++) {
            CGRect imageFrame;
            if (self.direction == XYOrigamiDirectionFromRight) {
                if(b == 0)
                    startAngle = -M_PI_2;
                else {
                    if (b%2)
                        startAngle = M_PI;
                    else
                        startAngle = -M_PI;
                }
                imageFrame = CGRectMake(frameWidth-(b+1)*foldWidth, 0, foldWidth, frameHeight);
            }
            else if (self.direction == XYOrigamiDirectionFromLeft) {
                if(b == 0)
                    startAngle = M_PI_2;
                else {
                    if (b%2)
                        startAngle = -M_PI;
                    else
                        startAngle = M_PI;
                }
                imageFrame = CGRectMake(b*foldWidth, 0, foldWidth, frameHeight);
            }
            else if (self.direction == XYOrigamiDirectionFromTop){
                if(b == 0)
                    startAngle = -M_PI_2;
                else {
                    if (b%2)
                        startAngle = M_PI;
                    else
                        startAngle = -M_PI;
                }
                imageFrame = CGRectMake(0, b*foldWidth, frameWidth, foldWidth);
            }
            else if(self.direction == XYOrigamiDirectionFromBottom){
                if(b == 0)
                    startAngle = M_PI_2;
                else {
                    if (b%2)
                        startAngle = -M_PI;
                    else
                        startAngle = M_PI;
                }
                imageFrame = CGRectMake(0, frameHeight-(b+1)*foldWidth, frameWidth, foldWidth);
            }
            CATransformLayer *transLayer = [self transformLayerFromImage:viewSnapShot Frame:imageFrame Duration:[self transitionDuration:transitionContext] AnchorPiont:anchorPoint StartAngle:startAngle EndAngle:0];
            [prevLayer addSublayer:transLayer];
            prevLayer = transLayer;
        }

        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [origamiLayer removeFromSuperlayer];
            // restore the to- and from- to the initial location
            toView.frame = containerView.frame;
            fromView.frame = containerView.frame;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

        [CATransaction setValue:[NSNumber numberWithFloat:[self transitionDuration:transitionContext]] forKey:kCATransactionAnimationDuration];
        CAAnimation *openAnimation = (self.direction < 2) ? [CAKeyframeAnimation animationWithKeyPath:@"position.x" function:openFunction fromValue:fromView.frame.origin.x + fromView.frame.size.width / 2 toValue:selfFrame.origin.x + fromView.frame.size.width / 2] : [CAKeyframeAnimation animationWithKeyPath:@"position.y" function:openFunction fromValue:fromView.frame.origin.y + fromView.frame.size.height / 2 toValue:selfFrame.origin.y + fromView.frame.size.height / 2];
        openAnimation.fillMode = kCAFillModeForwards;
        [openAnimation setRemovedOnCompletion:NO];
        [fromView.layer addAnimation:openAnimation forKey:@"position"];
        [CATransaction commit];
    } else {
        //set frame
        CGRect selfFrame = fromView.frame;
        CGPoint anchorPoint;
        if (self.direction == XYOrigamiDirectionFromRight) {
            // selfFrame.origin.x = fromView.frame.origin.x - fromView.bounds.size.width;
            toView.frame = CGRectOffset(containerView.frame, -toView.frame.size.width, 0);
            anchorPoint = CGPointMake(1, 0.5);
        }
        else if (self.direction == XYOrigamiDirectionFromLeft){
            // selfFrame.origin.x = fromView.frame.origin.x - fromView.bounds.size.width;
            toView.frame = CGRectOffset(containerView.frame, toView.frame.size.width, 0);
            anchorPoint = CGPointMake(0, 0.5);
        }
        else if (self.direction == XYOrigamiDirectionFromTop){
            // selfFrame.origin.y = fromView.frame.origin.y - fromView.bounds.size.height;
            toView.frame = CGRectOffset(containerView.frame, 0, toView.frame.size.height);
            anchorPoint = CGPointMake(0.5, 0);
        }
        else if (self.direction == XYOrigamiDirectionFromBottom){
            // selfFrame.origin.y = fromView.frame.origin.y + fromView.bounds.size.height;
            toView.frame = CGRectOffset(containerView.frame, 0, -toView.frame.size.height);
            anchorPoint = CGPointMake(0.5, 1);
        }

        UIGraphicsBeginImageContext(fromView.frame.size);
        [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // TODO: Retina snapshot.
        // UIImage *viewSnapShot = [self renderImageFromView:fromView withRect:fromView.frame];

        //set 3D depth
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.0/800.0;
        CALayer *origamiLayer = [CALayer layer];
        origamiLayer.frame = fromView.bounds;
        origamiLayer.backgroundColor = [UIColor colorWithRed:42.f/255.f green:42.f/255.f blue:42.f/255.f alpha:1.f].CGColor;
        origamiLayer.sublayerTransform = transform;
        [fromView.layer addSublayer:origamiLayer];

        //setup rotation angle
        double endAngle;
        CGFloat frameWidth = fromView.bounds.size.width;
        CGFloat frameHeight = fromView.bounds.size.height;
        CGFloat foldWidth = (self.direction < 2) ? frameWidth / (self.folds * 2) : frameHeight / (self.folds * 2);
        CALayer *prevLayer = origamiLayer;
        for (int b = 0; b < self.folds * 2; b++) {
            CGRect imageFrame;
            if (self.direction == XYOrigamiDirectionFromRight) {
                if (b == 0)
                    endAngle = -M_PI_2;
                else {
                    if (b % 2)
                        endAngle = M_PI;
                    else
                        endAngle = -M_PI;
                }
                imageFrame = CGRectMake(frameWidth - (b + 1) * foldWidth, 0, foldWidth, frameHeight);
            } else if (self.direction == XYOrigamiDirectionFromLeft) {
                if (b == 0)
                    endAngle = M_PI_2;
                else {
                    if (b % 2)
                        endAngle = -M_PI;
                    else
                        endAngle = M_PI;
                }
                imageFrame = CGRectMake(b * foldWidth, 0, foldWidth, frameHeight);
            } else if (self.direction == XYOrigamiDirectionFromTop) {
                if (b == 0)
                    endAngle = -M_PI_2;
                else {
                    if (b % 2)
                        endAngle = M_PI;
                    else
                        endAngle = -M_PI;
                }
                imageFrame = CGRectMake(0, b * foldWidth, frameWidth, foldWidth);
            } else if (self.direction == XYOrigamiDirectionFromBottom) {
                if (b == 0)
                    endAngle = M_PI_2;
                else {
                    if (b % 2)
                        endAngle = -M_PI;
                    else
                        endAngle = M_PI;
                }
                imageFrame = CGRectMake(0, frameHeight - (b + 1) * foldWidth, frameWidth, foldWidth);
            }
            CGFloat duration = [self transitionDuration:transitionContext];
            CATransformLayer *transLayer = [self transformLayerFromImage:viewSnapShot Frame:imageFrame Duration:duration AnchorPiont:anchorPoint StartAngle:0 EndAngle:endAngle];
            [prevLayer addSublayer:transLayer];
            prevLayer = transLayer;
        }

        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [origamiLayer removeFromSuperlayer];
            // restore the to- and from- to the initial location
            toView.frame = containerView.frame;
            fromView.frame = containerView.frame;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

        [CATransaction setValue:[NSNumber numberWithFloat:[self transitionDuration:transitionContext]] forKey:kCATransactionAnimationDuration];
        CAAnimation *openAnimation = (self.direction < 2) ? [CAKeyframeAnimation animationWithKeyPath:@"position.x" function:closeFunction fromValue:toView.frame.origin.x + toView.frame.size.width / 2 toValue:selfFrame.origin.x + toView.frame.size.width / 2] : [CAKeyframeAnimation animationWithKeyPath:@"position.y" function:closeFunction fromValue:toView.frame.origin.y + toView.frame.size.height / 2 toValue:selfFrame.origin.y + toView.frame.size.height / 2];
        openAnimation.fillMode = kCAFillModeForwards;
        [openAnimation setRemovedOnCompletion:NO];
        [toView.layer addAnimation:openAnimation forKey:@"position"];
        [CATransaction commit];
    }
}

- (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)frame
{
    // Create a new context of the desired size to render the image
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Translate it, to the desired position
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    // Render the view as image
    [view.layer renderInContext:context];
    // Fetch the image
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    // Cleanup
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (CATransformLayer *)transformLayerFromImage:(UIImage *)image Frame:(CGRect)frame Duration:(CGFloat)duration AnchorPiont:(CGPoint)anchorPoint StartAngle:(double)start EndAngle:(double)end;
{
    CATransformLayer *jointLayer = [CATransformLayer layer];
    jointLayer.anchorPoint = anchorPoint;
    CALayer *imageLayer = [CALayer layer];
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
    double shadowAniOpacity;
    if (anchorPoint.y == 0.5) {
        CGFloat layerWidth;
        if (anchorPoint.x == 0 ) //from left to right
        {
            layerWidth = image.size.width - frame.origin.x;
            jointLayer.frame = CGRectMake(0, 0, layerWidth, frame.size.height);
            if (frame.origin.x) {
                jointLayer.position = CGPointMake(frame.size.width, frame.size.height/2);
            }
            else {
                jointLayer.position = CGPointMake(0, frame.size.height/2);
            }
        }
        else { //from right to left
            layerWidth = frame.origin.x + frame.size.width;
            jointLayer.frame = CGRectMake(0, 0, layerWidth, frame.size.height);
            jointLayer.position = CGPointMake(layerWidth, frame.size.height/2);
        }

        //map image onto transform layer
        imageLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageLayer.anchorPoint = anchorPoint;
        imageLayer.position = CGPointMake(layerWidth*anchorPoint.x, frame.size.height/2);
        [jointLayer addSublayer:imageLayer];
        CGImageRef imageCrop = CGImageCreateWithImageInRect(image.CGImage, frame);
        imageLayer.contents = (__bridge id)imageCrop;
        imageLayer.backgroundColor = [UIColor clearColor].CGColor;

        //add shadow
        NSInteger index = frame.origin.x/frame.size.width;
        shadowLayer.frame = imageLayer.bounds;
        shadowLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        shadowLayer.opacity = 0.0;
        shadowLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        if (index%2) {
            shadowLayer.startPoint = CGPointMake(0, 0.5);
            shadowLayer.endPoint = CGPointMake(1, 0.5);
            shadowAniOpacity = (anchorPoint.x)?0.24:0.32;
        }
        else {
            shadowLayer.startPoint = CGPointMake(1, 0.5);
            shadowLayer.endPoint = CGPointMake(0, 0.5);
            shadowAniOpacity = (anchorPoint.x)?0.32:0.24;
        }
    }
    else{
        CGFloat layerHeight;
        if (anchorPoint.y == 0 ) //from top
        {
            layerHeight = image.size.height - frame.origin.y;
            jointLayer.frame = CGRectMake(0, 0, frame.size.width, layerHeight);
            if (frame.origin.y) {
                jointLayer.position = CGPointMake(frame.size.width/2, frame.size.height);
            }
            else {
                jointLayer.position = CGPointMake(frame.size.width/2, 0);
            }
        }
        else { //from bottom
            layerHeight = frame.origin.y + frame.size.height;
            jointLayer.frame = CGRectMake(0, 0, frame.size.width, layerHeight);
            jointLayer.position = CGPointMake(frame.size.width/2, layerHeight);
        }

        //map image onto transform layer
        imageLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageLayer.anchorPoint = anchorPoint;
        imageLayer.position = CGPointMake(frame.size.width/2, layerHeight*anchorPoint.y);
        [jointLayer addSublayer:imageLayer];
        CGImageRef imageCrop = CGImageCreateWithImageInRect(image.CGImage, frame);
        imageLayer.contents = (__bridge id)imageCrop;
        imageLayer.backgroundColor = [UIColor clearColor].CGColor;

        //add shadow
        NSInteger index = frame.origin.y/frame.size.height;
        shadowLayer.frame = imageLayer.bounds;
        shadowLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        shadowLayer.opacity = 0.0;
        shadowLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        if (index%2) {
            shadowLayer.startPoint = CGPointMake(0.5, 0);
            shadowLayer.endPoint = CGPointMake(0.5, 1);
            shadowAniOpacity = (anchorPoint.x)?0.24:0.32;
        }
        else {
            shadowLayer.startPoint = CGPointMake(0.5, 1);
            shadowLayer.endPoint = CGPointMake(0.5, 0);
            shadowAniOpacity = (anchorPoint.x)?0.32:0.24;
        }
    }

    [imageLayer addSublayer:shadowLayer];

    //animate open/close animation
    CABasicAnimation *animation = (anchorPoint.y == 0.5)?[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"]:[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setDuration:duration];
    [animation setFromValue:[NSNumber numberWithDouble:start]];
    [animation setToValue:[NSNumber numberWithDouble:end]];
    [animation setRemovedOnCompletion:NO];
    [jointLayer addAnimation:animation forKey:@"jointAnimation"];

    //animate shadow opacity
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:duration];
    [animation setFromValue:[NSNumber numberWithDouble:(start)?shadowAniOpacity:0]];
    [animation setToValue:[NSNumber numberWithDouble:(start)?0:shadowAniOpacity]];
    [animation setRemovedOnCompletion:NO];
    [shadowLayer addAnimation:animation forKey:nil];

    return jointLayer;
}

// creates a snapshot for the given view
- (UIView *)createSnapshotFromView:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left
{
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / (float)self.folds;

    UIView *snapshotView;

    if (!afterUpdates) {
        // create a regular snapshot
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    } else {
        // for the to- view for some reason the snapshot takes a while to create. Here we place the snapshot within
        // another view, with the same bckground color, so that it is less noticeable when the snapshot initially renders
        snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView* snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
    }

    // create a shadow
    UIView *snapshotWithShadowView = [self addShadowToView:snapshotView reverse:left];

    // add to the container
    [containerView addSubview:snapshotWithShadowView];

    // set the anchor to the left or right edge of the view
    snapshotWithShadowView.layer.anchorPoint = CGPointMake(left ? 0.0 : 1.0, 0.5);

    return snapshotWithShadowView;
}


// adds a gradient to an image by creating a containing UIView with both the given view
// and the gradient as subviews
- (UIView *)addShadowToView:(UIView *)view reverse:(BOOL)reverse
{
    // create a view with the same frame
    UIView *viewWithShadow = [[UIView alloc] initWithFrame:view.frame];

    // create a shadow
    UIView *shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];

    // add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];

    // place the shadow on top
    [viewWithShadow addSubview:shadowView];

    return viewWithShadow;
}

@end
