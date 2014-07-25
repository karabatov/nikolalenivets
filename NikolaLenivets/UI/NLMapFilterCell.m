//
//  NLMapFilterCell.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 25.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMapFilterCell.h"

@implementation NLMapFilterCell

- (void)awakeFromNib
{
    self.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
}

- (void)setActivated:(BOOL)activated
{
    _activated = activated;
    if (_activated) {
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.checkmarkButton setImage:[UIImage imageNamed:@"map-checked.png"] forState:UIControlStateNormal];
    } else {
        [self.titleLabel setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:99.0f/255.0f alpha:1.0f]];
        [self.checkmarkButton setImage:[UIImage imageNamed:@"map-unchecked.png"] forState:UIControlStateNormal];
    }
}

@end
