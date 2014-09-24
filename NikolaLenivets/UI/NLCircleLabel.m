//
//  NLCircleLabel.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 24.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLCircleLabel.h"
#import "NSAttributedString+Kerning.h"

@implementation NLCircleLabel

- (instancetype)initWithNumber:(NSUInteger)number
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];

        UIImageView *circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-car-circle.png"]];
        [circle setTranslatesAutoresizingMaskIntoConstraints:NO];

        UILabel *numberLabel = [[UILabel alloc] init];
        [numberLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        numberLabel.attributedText = [NSAttributedString kernedStringForString:[NSString stringWithFormat:@"%lu", (unsigned long)number] withFontName:NLMonospacedBoldFont fontSize:9 kerning:0.f andColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];

        [self addSubview:circle];
        [self addSubview:numberLabel];

        NSDictionary *views = NSDictionaryOfVariableBindings(circle, numberLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[circle(15)]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[circle(15)]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[numberLabel]-(>=0)-|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[numberLabel]-(>=0)-|" options:kNilOptions metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:15.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:15.f]];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.f) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:-0.5f]];
        } else {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.0f]];
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.f]];
    }
    return self;
}

@end
