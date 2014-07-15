//
//  NLEventsCollectionViewController.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;
#import "CHTCollectionViewWaterfallLayout.h"
#import "NLEventGroup.h"

/**
 Used to display events in a Pinterest-like pattern using `CHTCollectionViewWaterfallLayout`.
 */
@interface NLEventsCollectionViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

/**
 Title on the (surprise) title bar.
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 Unread items count.
 */
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;

/**
 Collection view to display events.
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 `Double cheeseburger` menu button pressed.
 */
- (IBAction)back:(id)sender;

/**
 Designated initializer to init the controller with an event group.
 */
- (instancetype)initWithGroup:(NLEventGroup *)group;

@end
