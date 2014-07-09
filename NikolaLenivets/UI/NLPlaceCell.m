//
//  NLPlaceCell.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLPlaceCell.h"

@implementation NLPlaceCell
{
    NLPlace *_place;
}


- (void)populateWithPlace:(NLPlace *)place
{
    _place = place;
    self.hidden = _place == nil;
    self.unreadIndicator.hidden = _place == nil;
    self.distanceLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.distanceLabel.font.pointSize];
    self.nameLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.nameLabel.font.pointSize];
    self.distanceLabel.text = @"∞ км";
    self.nameLabel.text = [_place.title uppercaseString];
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.image setImageWithURL:[NSURL URLWithString:_place.thumbnail] completed:^(UIImage *image, NSError *err, SDImageCacheType cacheType) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }];
}

@end
