//
//  NLPlaceCell.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLPlace.h"

@interface NLPlaceCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *unreadIndicator;

- (void)populateWithPlace:(NLPlace *)place;

- (void)makeImageGrayscale:(BOOL)shouldMakeImageGrayscale;

+ (NSString *)reuseIdentifier;

@end
