//
//  NLCollectionCell.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "NLNewsEntry.h"
#import "NLEvent.h"
#import <AsyncImageView.h>

@interface NLCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *counterLabel;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *monthLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *previewLabel;
@property (strong, nonatomic) AsyncImageView *thumbnail;
@property (strong, nonatomic) UIImageView *unreadIndicator;
@property (strong, nonatomic) NSLayoutConstraint *thumbnailHeight;
@property (strong, nonatomic) NSLayoutConstraint *thumbnailBottomMargin;
@property (strong, nonatomic) NSLayoutConstraint *monthRightMargin;
@property (strong, nonatomic) UIImageView *alarmIcon;

+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry;
+ (CGFloat)heightForCellWithEvent:(NLEvent *)event;

- (void)populateFromNewsEntry:(NLNewsEntry *)entry;
- (void)populateFromEvent:(NLEvent *)event;

+ (NSString *)reuseIdentifier;

@end
