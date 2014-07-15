//
//  NLSectionHeader.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSectionHeader.h"

@implementation NLSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dayOrderLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        [self addSubview:self.dayOrderLabel];
        [self addSubview:self.dateLabel];
        [self.dayOrderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *views = @{ @"day": self.dayOrderLabel, @"date": self.dateLabel };
        NSDictionary *metrics = @{ @"left": @23, @"top": @4, @"bottom": @6 ,@"hrsp": @10 };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[day]-(>=hrsp)-[date]-(>=hrsp)-|" options:kNilOptions metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[date]-(bottom)-|" options:kNilOptions metrics:metrics views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dayOrderLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:1.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

        self.dayOrderLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
        self.dayOrderLabel.textColor = [UIColor darkGrayColor];
        [self.dayOrderLabel setAdjustsFontSizeToFitWidth:YES];
        [self.dayOrderLabel setMinimumScaleFactor:0.2f];
        self.dateLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:13];
    }
    return self;
}

@end
