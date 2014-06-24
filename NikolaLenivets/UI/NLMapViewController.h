//
//  NLMapViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 23.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLMapViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UIScrollView *mapScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIView *resizableView;
@property (strong, nonatomic) IBOutlet UIView *placeDetailsMenu;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *distanceToPlace;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)showMyLocation:(id)sender;

@end
