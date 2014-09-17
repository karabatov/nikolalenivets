//
//  NLSearchTableViewHeader.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 14.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchTableViewHeader.h"

@interface NLSearchTableViewHeader ()

/**
 Section title label.
 */
@property (strong, nonatomic) UILabel *sectionTitleLabel;

@end

@implementation NLSearchTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];

        self.sectionTitleLabel = [[UILabel alloc] init];
        [self.sectionTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self.contentView addSubview:self.sectionTitleLabel];

        NSDictionary *views = @{ @"title": self.sectionTitleLabel };
        NSDictionary *metrics = @{ @"marginH": @17 };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=marginH)-[title]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.sectionTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:1.5f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.sectionTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.5f]];

        [self resetBorderColor];
    }
    return self;
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:18],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:126.f/255.f green:126.f/255.f blue:126.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:2.2f] };
    if (sectionTitle) {
        self.sectionTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:sectionTitle attributes:attributes];
    } else {
        self.sectionTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    }
}

- (void)resetBorderColor
{
    UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.layer setBorderColor:borderGray.CGColor];
    [self.layer setBorderWidth:0.5f];
}

+ (NSString *)reuseSectionId
{
    return @"NLSearchTableViewHeader";
}

@end
