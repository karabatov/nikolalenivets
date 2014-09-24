//
//  NLCircleLabel.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 24.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

/**
 A view with a small circle and a number inside for the static map screen.
 */
@interface NLCircleLabel : UIView

/**
 Init with number in the circle.
 */
- (instancetype)initWithNumber:(NSUInteger)number;

@end
