//
//  NLSectionHeader.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSectionHeader.h"

@implementation NLSectionHeader


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
    self.clipsToBounds = YES;
    self.dayOrderLabel = [[UILabel alloc] init];
    self.dateLabel = [[UILabel alloc] init];
    [self addSubview:self.dayOrderLabel];
    [self addSubview:self.dateLabel];
    [self.dayOrderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{ @"day": self.dayOrderLabel, @"date": self.dateLabel };
    NSDictionary *metrics = @{ @"left": @23, @"top": @0, @"bottom": @0 ,@"hrsp": @10 };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[day]-(>=hrsp)-[date]-(>=hrsp)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[date]-(>=bottom)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dayOrderLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:1.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-1.f]];

    self.dayOrderLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.dayOrderLabel.textColor = [UIColor darkGrayColor];
    [self.dayOrderLabel setAdjustsFontSizeToFitWidth:YES];
    [self.dayOrderLabel setMinimumScaleFactor:0.2f];
    self.dateLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:13];

    [self resetBorderColor];
}


- (void)resetBorderColor
{
    UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.layer setBorderColor:borderGray.CGColor];
    [self.layer setBorderWidth:0.5f];
}


+ (NSString *)reuseSectionId
{
    return @"collectionsection";
}

@end
