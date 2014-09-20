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
#import "NLSectionHeader.h"

@interface NLDetailsViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomSpace;
@property (weak, nonatomic) IBOutlet UIWebView *firstPartWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTextHeight;
@property (weak, nonatomic) IBOutlet UIWebView *secondPartLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTextHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *countView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet AsyncImageView *galleryCover;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *galleryHeight;
@property (weak, nonatomic) IBOutlet UIButton *showGalleryButton;
@property (weak, nonatomic) IBOutlet UIImageView *unreadIndicator;
@property (weak, nonatomic) IBOutlet NLSectionHeader *eventDayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventDayHeight;
@property (weak, nonatomic) IBOutlet AsyncImageView *placeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeImageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *blueGradient;
@property (weak, nonatomic) IBOutlet UIImageView *alarmIcon;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

- (id)initWithEvent:(NLEvent *)event withOrderInGroup:(NSInteger)order;
- (id)initWithEntry:(NLNewsEntry *)entry;
- (id)initWithPlace:(NLPlace *)place currentLocation:(CLLocation *)currentLocation;
- (IBAction)showGallery:(id)sender;

@end
