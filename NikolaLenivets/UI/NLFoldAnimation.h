//
//  NLFoldAnimation.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;

@interface NLFoldAnimation : NSObject <UIViewControllerAnimatedTransitioning>


/**
 The direction of the animation.
 */
@property (nonatomic, assign) BOOL reverse;


/**
 Number of folds.
 */
@property (nonatomic) NSUInteger folds;


@end
