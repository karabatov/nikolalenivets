//
//  NLSearchViewController.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 12.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CHTCollectionViewWaterfallLayout.h>

/**
 Manages search.
 */
@interface NLSearchViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource>

@end
