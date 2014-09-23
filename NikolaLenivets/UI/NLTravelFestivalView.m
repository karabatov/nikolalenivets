//
//  NLTravelFestivalView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelFestivalView.h"
#import "NLBorderedLabel.h"
#import "NSAttributedString+Kerning.h"

@implementation NLTravelFestivalView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIColor *textColor = [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f];

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    titleLabel.attributedText = [NSAttributedString kernedStringForString:@"ФЕСТИВАЛЬНЫЙ ТРАНСФЕР" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UILabel *travelTimeLabel = [[UILabel alloc] init];
    [travelTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    travelTimeLabel.attributedText = [NSAttributedString kernedStringForString:@"РАСЧЕТНОЕ ВРЕМЯ В ПУТИ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UIView *dashLine = [[UIView alloc] init];
    [dashLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dashLine setBackgroundColor:[UIColor colorWithRed:244.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1.f]];

    UIImageView *transferImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-festival-transfer.png"]];
    [transferImage setTranslatesAutoresizingMaskIntoConstraints:NO];

    NLBorderedLabel *borderedTimeLabel = [[NLBorderedLabel alloc] initWithAttributedText:[NSAttributedString kernedStringForString:@"4 ЧАСА" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor]];
    [borderedTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:titleLabel];
    [self addSubview:travelTimeLabel];
    [self addSubview:dashLine];
    [self addSubview:transferImage];
    [self addSubview:borderedTimeLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, travelTimeLabel, dashLine, transferImage, borderedTimeLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[titleLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[travelTimeLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dashLine]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(11)-[transferImage(291.5)]-(>=17.5)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[borderedTimeLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3.5-[titleLabel]-36.5-[transferImage(181.5)]-15.5-[dashLine(0.5)]-15-[travelTimeLabel]-17.5-[borderedTimeLabel]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:travelTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:borderedTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
}

@end
