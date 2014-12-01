//
//  UIImage+Tint.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 01/12/14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *)imageTintedWithColor:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

@end
