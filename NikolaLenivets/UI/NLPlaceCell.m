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
    __strong NLPlace *_place;
}


- (void)populateWithPlace:(NLPlace *)place
{
    _place = place;
    self.unreadIndicator.hidden = _place == nil;
    self.distanceLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.distanceLabel.font.pointSize];
    self.nameLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:self.nameLabel.font.pointSize];
    self.distanceLabel.text = @"0.0 км";
    self.nameLabel.text = [_place.title uppercaseString];
    self.image.imageURL = [NSURL URLWithString:_place.thumbnail];
}

@end
