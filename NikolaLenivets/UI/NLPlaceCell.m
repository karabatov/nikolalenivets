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
    self.distanceLabel.text = @"0.0 км";
    self.nameLabel.text = _place.title;
    self.image.imageURL = [NSURL URLWithString:_place.thumbnail];
}

@end
