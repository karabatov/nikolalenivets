//
//  NLBorderedLabel.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLBorderedLabel.h"

@implementation NLBorderedLabel

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];

        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        titleLabel.attributedText = attributedText;

        [self addSubview:titleLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[titleLabel]-6-|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[titleLabel]-4-|" options:kNilOptions metrics:nil views:views]];

        [self.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.layer setBorderWidth:1.f];
    }
    return self;
}

@end
