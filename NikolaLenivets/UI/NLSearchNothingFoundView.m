//
//  NLSearchNothingFoundView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 17.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchNothingFoundView.h"

@implementation NLSearchNothingFoundView
{
    UILabel *_nothingLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nothingLabel = [[UILabel alloc] init];
        [_nothingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self addSubview:_nothingLabel];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_nothingLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_nothingLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];

        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:18],
                                      NSForegroundColorAttributeName: [UIColor colorWithRed:202.f/255.f green:202.f/255.f blue:202.f/255.f alpha:1.f],
                                      NSKernAttributeName: [NSNumber numberWithFloat:2.2f] };
        _nothingLabel.attributedText = [[NSAttributedString alloc] initWithString:@"НИЧЕГО НЕ НАЙДЕНО" attributes:attributes];
    }
    return self;
}

@end
