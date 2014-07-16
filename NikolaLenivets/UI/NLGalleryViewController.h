//
//  NLGalleryViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import <UIPhotoGalleryViewController.h>
#import "NLGallery.h"

@interface NLGalleryViewController : UIViewController <UIPhotoGalleryDataSource, UIPhotoGalleryDelegate>

@property (weak, nonatomic) IBOutlet UIPhotoGalleryView *galleryView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *backTitleLabel;

- (id)initWithGallery:(NLGallery *)gallery;

@end
