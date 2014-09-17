//
//  NLPlaceCell.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLPlace.h"
#import <UIImageView+WebCache.h>

@interface NLPlaceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)populateWithPlace:(NLPlace *)place;

- (void)makeImageGrayscale:(BOOL)shouldMakeImageGrayscale;

+ (NSString *)reuseIdentifier;

@end
