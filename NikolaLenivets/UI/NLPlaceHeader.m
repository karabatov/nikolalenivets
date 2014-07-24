//
//  NLPlaceHeader.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 22.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlaceHeader.h"

@implementation NLPlaceHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    self.objectCountLabel = [[UILabel alloc] init];
    self.categoryNameLabel = [[UILabel alloc] init];
    UIImageView *countCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"object-count.png"]];
    [self addSubview:countCircle];
    [self addSubview:self.objectCountLabel];
    [self addSubview:self.categoryNameLabel];
    [self.objectCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.categoryNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [countCircle setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{ @"count": self.objectCountLabel, @"name": self.categoryNameLabel, @"circle": countCircle };
    NSDictionary *metrics = @{ @"circletop": @5.5, @"top": @4, @"bottom": @6, @"width": @18, @"height": @18 };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[count]-(bottom)-[name]-(bottom)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(circletop)-[circle(height)]" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[circle(width)]" options:kNilOptions metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:countCircle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.objectCountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

    self.objectCountLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.objectCountLabel.textColor = [UIColor blackColor];
    self.categoryNameLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:12];
    self.categoryNameLabel.textColor = [UIColor blackColor];
}

@end
