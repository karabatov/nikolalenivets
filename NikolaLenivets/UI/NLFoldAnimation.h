//
//  NLFoldAnimation.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;

typedef double (^KeyframeParametricBlock)(double);

@interface CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path function:(KeyframeParametricBlock)block fromValue:(double)fromValue toValue:(double)toValue;

@end

enum {
	XYOrigamiDirectionFromRight     = 0,
	XYOrigamiDirectionFromLeft      = 1,
    XYOrigamiDirectionFromTop       = 2,
    XYOrigamiDirectionFromBottom    = 3,
};
typedef NSUInteger XYOrigamiDirection;

@interface NLFoldAnimation : NSObject <UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 Number of folds.
 */
@property (nonatomic) NSUInteger folds;

/**
 Fold direction.
 */
@property (nonatomic) XYOrigamiDirection direction;

/**
 Fold duration.
 */
@property (nonatomic) double duration;

/**
 Offset to apply to sliding view.
 */
@property (nonatomic) CGFloat offset;

@end
