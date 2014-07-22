//
//  NLPlaceHeader.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 22.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

/**
 Section header for displaying place categories.
 */
@interface NLPlaceHeader : UICollectionReusableView

/**
 Used to display object count in a category.
 */
@property (strong, nonatomic) UILabel *objectCountLabel;

/**
 Used to display the title of the category.
 */
@property (strong, nonatomic) UILabel *categoryNameLabel;

@end
