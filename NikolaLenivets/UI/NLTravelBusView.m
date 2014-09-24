//
//  NLTravelBusView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelBusView.h"
#import "NLBorderedLabel.h"
#import "NSAttributedString+Kerning.h"

@implementation NLTravelBusView

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
    titleLabel.attributedText = [NSAttributedString kernedStringForString:@"НА АВТОБУСЕ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UIImageView *transferImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-bus-route.png"]];
    [transferImage setTranslatesAutoresizingMaskIntoConstraints:NO];

    NLBorderedLabel *borderedTimeLabel = [[NLBorderedLabel alloc] initWithAttributedText:[NSAttributedString kernedStringForString:@"ЕЖЕДНЕВНО В 14:30 И 15:30" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor]];
    [borderedTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    UILabel *nextLabel = [[UILabel alloc] init];
    [nextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    nextLabel.attributedText = [NSAttributedString kernedStringForString:@"ДАЛЕЕ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UILabel *taxiLabel = [[UILabel alloc] init];
    [taxiLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    taxiLabel.attributedText = [NSAttributedString kernedStringForString:@"На такси до Никола-Ленивца." withFontName:NLSerifFont fontSize:18.f kerning:0.7f andColor:textColor];

    UILabel *taxiHeaderLabel = [[UILabel alloc] init];
    [taxiHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    taxiHeaderLabel.attributedText = [NSAttributedString kernedStringForString:@"ТЕЛЕФОН ТАКСИ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UILabel *taxiPhoneLabel = [[UILabel alloc] init];
    [taxiPhoneLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    taxiPhoneLabel.attributedText = [NSAttributedString kernedStringForString:@"+7 (48434) 4-85-00" withFontName:NLSerifFont fontSize:18.f kerning:0.7f andColor:textColor];
    [taxiPhoneLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialPhone)];
    [taxiPhoneLabel addGestureRecognizer:tap];

    [self addSubview:titleLabel];
    [self addSubview:transferImage];
    [self addSubview:borderedTimeLabel];
    [self addSubview:nextLabel];
    [self addSubview:taxiLabel];
    [self addSubview:taxiHeaderLabel];
    [self addSubview:taxiPhoneLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, transferImage, borderedTimeLabel, nextLabel, taxiLabel, taxiHeaderLabel, taxiPhoneLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[titleLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16)-[transferImage(270.5)]-(>=33.5)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[borderedTimeLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[nextLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16)-[taxiLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[taxiHeaderLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16)-[taxiPhoneLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3.5-[titleLabel]-36.5-[transferImage(61.5)]-10.5-[borderedTimeLabel]-17-[nextLabel]-16-[taxiLabel]-15-[taxiHeaderLabel]-15-[taxiPhoneLabel]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:borderedTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nextLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:taxiHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
}

- (void)dialPhone
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://+74843448500"]];
}

@end
