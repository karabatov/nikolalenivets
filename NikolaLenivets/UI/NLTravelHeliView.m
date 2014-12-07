//
//  NLTravelHeliView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelHeliView.h"
#import "NLBorderedLabel.h"
#import "NSAttributedString+Kerning.h"
#import "UIApplication+NLDirections.h"

@implementation NLTravelHeliView

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
    titleLabel.attributedText = [NSAttributedString kernedStringForString:NSLocalizedString(@"НА ВЕРТОЛЕТЕ", @"BY HELICOPTER") withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UILabel *coordLabel = [[UILabel alloc] init];
    [coordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    coordLabel.attributedText = [NSAttributedString kernedStringForString:NSLocalizedString(@"КООРДИНАТЫ ДЛЯ ПОСАДКИ", @"Heli - landing coordinates") withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UILabel *travelTimeLabel = [[UILabel alloc] init];
    [travelTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    travelTimeLabel.attributedText = [NSAttributedString kernedStringForString:NSLocalizedString(@"РАСЧЕТНОЕ ВРЕМЯ В ПУТИ", @"Heli - Estimated travel time") withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UIView *dashLine = [[UIView alloc] init];
    [dashLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dashLine setBackgroundColor:[UIColor colorWithRed:244.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1.f]];

    UIButton *coordsImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [coordsImage setImage:[UIImage imageNamed:@"travel-heli-coords.png"] forState:UIControlStateNormal];
    [coordsImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [coordsImage addTarget:self action:@selector(coordsImageTapped) forControlEvents:UIControlEventTouchUpInside];

    NLBorderedLabel *borderedTimeLabel = [[NLBorderedLabel alloc] initWithAttributedText:[NSAttributedString kernedStringForString:NSLocalizedString(@"45 МИНУТ", @"Heli - 45 minutes") withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor]];
    [borderedTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:titleLabel];
    [self addSubview:coordLabel];
    [self addSubview:travelTimeLabel];
    [self addSubview:dashLine];
    [self addSubview:coordsImage];
    [self addSubview:borderedTimeLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, coordLabel, travelTimeLabel, dashLine, coordsImage, borderedTimeLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[titleLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[coordLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[travelTimeLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dashLine]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(11)-[coordsImage(297.5)]-(>=11.5)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[borderedTimeLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3.5-[titleLabel]-32-[coordLabel]-18-[coordsImage(20)]-20-[dashLine(0.5)]-15-[travelTimeLabel]-17.5-[borderedTimeLabel]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:coordLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:travelTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:borderedTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
}

- (void)coordsImageTapped
{
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(54.749725, 35.600477);
    [[UIApplication sharedApplication] openDirectionsWithCoordinate:endingCoord];
}

@end
