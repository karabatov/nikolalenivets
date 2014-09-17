//
//  NLSearchTableViewCell.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 13.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLFlowLayout.h"

/**
 Wrapper cell for collection views in Search.
 */
@interface NLSearchTableViewCell : UITableViewCell

/**
 Collection view to display the actual search results.
 */
@property (strong, nonatomic) UICollectionView *collectionView;

/**
 Class reuse identifier.
 */
+ (NSString *)reuseIdentifier;

/**
 New configured flow layout instance.
 */
+ (NLFlowLayout *)newFlowLayout;

@end
