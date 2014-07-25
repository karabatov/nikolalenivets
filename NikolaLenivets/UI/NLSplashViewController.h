//
//  NLSplashViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 25.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

@interface NLSplashViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *compass;
@property (weak, nonatomic) IBOutlet UIImageView *splashTop;
@property (weak, nonatomic) IBOutlet UIView *blackStrip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackStripWidth;
@property (weak, nonatomic) IBOutlet UILabel *nikolaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenivetsLabel;

@end
