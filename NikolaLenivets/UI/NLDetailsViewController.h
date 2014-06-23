//
//  NLNewsEntryViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTAttributedLabel.h>
#import <AsyncImageView.h>
#import "NLNewsEntry.h"
#import "NLEvent.h"
#import "NLPlace.h"

@interface NLDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *firstPartLabel;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *secondPartLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *countView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *capitalLetter;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet AsyncImageView *galleryCover;
@property (weak, nonatomic) IBOutlet UIButton *showGalleryButton;
@property (weak, nonatomic) IBOutlet UILabel *detailsViewTitleLabel;

- (id)initWithEvent:(NLEvent *)event;
- (id)initWithEntry:(NLNewsEntry *)entry;
- (id)initWithPlace:(NLPlace *)place currentLocation:(CLLocation *)currentLocation;
- (IBAction)showGallery:(id)sender;

- (IBAction)back:(id)sender;

@end
