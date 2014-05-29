//
//  NLPlaceCell.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLPlace.h"
#import "AsyncImageView.h"

@interface NLPlaceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)populateWithPlace:(NLPlace *)place;

@end
