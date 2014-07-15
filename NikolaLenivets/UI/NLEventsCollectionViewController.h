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

@interface NLEventsCollectionViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)back:(id)sender;

- (instancetype)initWithGroup:(NLEventGroup *)group;

@end
