//
//  NLTravelTypeSectionView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelTypeSectionView.h"

@interface NLTravelTypeSectionView ()

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation NLTravelTypeSectionView

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
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:[UIColor whiteColor]];

    self.headerLabel = [[UILabel alloc] init];
    [self.headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.headerLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    self.headerLabel.textColor = [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f];

    [self addSubview:self.headerLabel];

    NSDictionary *views = @{ @"header": self.headerLabel };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[header]-(>=17)-|" options:kNilOptions metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=1)-[header]-(>=1)-|" options:kNilOptions metrics:0 views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-2.f]];

    [self.layer setBorderColor:[UIColor colorWithRed:244.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1.f].CGColor];
    [self.layer setBorderWidth:0.5f];
}

- (void)addTarget:(id)target withAction:(SEL)action
{
    if (self.tap) {
        [self removeGestureRecognizer:self.tap];
        self.tap = nil;
    }
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:self.tap];
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    switch (tag) {
        case NLTravelTypeCar:
            self.headerLabel.text = @"АВТОМОБИЛЬ";
            break;
        case NLTravelTypeTrain:
            self.headerLabel.text = @"ЭЛЕКТРИЧКА";
            break;
        case NLTravelTypeBus:
            self.headerLabel.text = @"АВТОБУС";
            break;
        case NLTravelTypeFestival:
            self.headerLabel.text = @"ФЕСТИВАЛЬНЫЙ ТРАНСФЕР";
            break;
        case NLTravelTypeHeli:
            self.headerLabel.text = @"ВЕРТОЛЕТ";
            break;

        default:
            break;
    }
}

@end
