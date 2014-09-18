//
//  NLPlaceCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlaceCell.h"
#import "UIImage+Grayscale.h"
#import "NSAttributedString+Kerning.h"

@implementation NLPlaceCell
{
    NLPlace *_place;
    UIImage *_coloredImage;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

        self.unreadIndicator = [[UIImageView alloc] init];
        [self.unreadIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.distanceLabel = [[UILabel alloc] init];
        [self.distanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.distanceLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
        self.distanceLabel.textColor = [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f];

        self.image = [[AsyncImageView alloc] init];
        [self.image setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.image setContentMode:UIViewContentModeScaleAspectFill];
        [self.image setClipsToBounds:YES];

        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.nameLabel setNumberOfLines:0];

        [self.contentView addSubview:self.unreadIndicator];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.nameLabel];

        NSDictionary *views = @{ @"unread": self.unreadIndicator, @"dist": self.distanceLabel, @"image": self.image, @"name": self.nameLabel };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[unread(7)]-4.5-[dist]-(>=17)-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[image(125.5)]-(>=17)-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[name]-17-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16.5-[unread(7)]-5-[image(125.5)]-3-[name]-(>=0)-|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.distanceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.unreadIndicator attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-1.f]];

        UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        [self.contentView.layer setBorderColor:borderGray.CGColor];
        [self.contentView.layer setBorderWidth:0.5f];
    }
    return self;
}


- (void)populateWithPlace:(NLPlace *)place
{
    _place = place;
    self.distanceLabel.text = @"∞ КМ";
    self.nameLabel.attributedText = [NSAttributedString attributedStringForPlaceName:[_place.title uppercaseString]];
    [self.image setImageURL:[NSURL URLWithString:_place.thumbnail]];
    [self setUnreadStatus:place.itemStatus];
}


- (void)setUnreadStatus:(NLItemStatus)status
{
    switch (status) {
        case NLItemStatusNew:
            [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-red.png"]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusUnread:
            [self.unreadIndicator setImage:[UIImage imageNamed:@"unread-indicator-gray.png"]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusRead:
            [self.unreadIndicator setImage:nil];
            [self.unreadIndicator setHidden:YES];
            break;

        default:
            break;
    }
}


- (void)prepareForReuse
{
    self.image.image = nil;
}


- (void)makeImageGrayscale:(BOOL)shouldMakeImageGrayscale
{
    if (self.image.image && shouldMakeImageGrayscale) {
        _coloredImage = self.image.image;
        [UIView animateWithDuration:0.25f animations:^{
            [self.image setImage:[_coloredImage convertImageToGrayscale]];
        }];
    } else {
        if (_coloredImage) {
            [UIView animateWithDuration:0.25f animations:^{
                [self.image setImage:_coloredImage];
            }];
        }
    }
}


+ (NSString *)reuseIdentifier
{
    return @"NLPlaceCell";
}


@end
