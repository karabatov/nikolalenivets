//
//  NLSectionHeader.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

/**
 Section header for event or news list collection view.
 */
@interface NLSectionHeader : UICollectionReusableView

/**
 Used to display string representation of the day number within a group event.
 */
@property (strong, nonatomic) UILabel *dayOrderLabel;

/**
 Used to display the date of events in current section.
 */
@property (strong, nonatomic) UILabel *dateLabel;

/**
 Reset border color.
 */
- (void)resetBorderColor;

@end
