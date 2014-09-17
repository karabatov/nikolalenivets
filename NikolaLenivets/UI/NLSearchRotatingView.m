//
//  NLSearchRotatingView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 16.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchRotatingView.h"

@interface NLSearchRotatingView ()

@property (strong, nonatomic) UIImageView *searchRotatingImage;

@end

@implementation NLSearchRotatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.searchRotatingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-rotating.png"]];
        [self.searchRotatingImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.searchRotatingImage];

        self.imageHeight = [NSLayoutConstraint constraintWithItem:self.searchRotatingImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:25.f];
        [self addConstraint:self.imageHeight];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchRotatingImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchRotatingImage attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchRotatingImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchRotatingImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];

        [self startAnimating];
    }
    return self;
}

- (void)startAnimating
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;

    [self.searchRotatingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
