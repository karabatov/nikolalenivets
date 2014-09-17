//
//  NLPlaceCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlaceCell.h"
#import "UIImage+Grayscale.h"

@implementation NLPlaceCell
{
    NLPlace *_place;
    UIImage *_coloredImage;
}


- (void)populateWithPlace:(NLPlace *)place
{
    _place = place;
    self.hidden = _place == nil;
    self.unreadIndicator.hidden = _place == nil;
    self.distanceLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.distanceLabel.font.pointSize];
    self.nameLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.nameLabel.font.pointSize];
    self.distanceLabel.text = @"∞ КМ";
    self.nameLabel.text = [_place.title uppercaseString];
    UIColor *borderGray = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    [self.contentView.layer setBorderColor:borderGray.CGColor];
    [self.contentView.layer setBorderWidth:0.5f];
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.image sd_setImageWithURL:[NSURL URLWithString:_place.thumbnail] completed:^(UIImage *image, NSError *err, SDImageCacheType cacheType, NSURL *url) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }];
    [self setUnreadStatus:place.itemStatus];
}


- (void)setUnreadStatus:(NLItemStatus)status
{
    switch (status) {
        case NLItemStatusNew:
            [self.unreadIndicator setTextColor:[UIColor colorWithRed:255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusUnread:
            [self.unreadIndicator setTextColor:[UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0f]];
            [self.unreadIndicator setHidden:NO];
            break;
        case NLItemStatusRead:
            [self.unreadIndicator setTextColor:[UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0f]];
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
