//
//  NLMapFilter.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 25.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "NLMapViewController.h"

/**
 An overlay screen for showing the object category filter on a map.
 */
@interface NLMapFilter : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NLMapViewController *parentMap;

/**
 Designated init for class.
 
 @param categories All available categories.
 @param selectedCat Categories, which are selected for display.
 @return Initialized instance of class.
 */
- (instancetype)initWithFrame:(CGRect)frame andCategories:(NSArray *)categories selected:(NSMutableArray *)selectedCat;

/**
 Display the final graphical state of the view with animation.
 */
- (void)displayAnimated;

@end
