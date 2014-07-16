//
//  NLNewsListController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 24.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

enum  {
    LeftTable  = 0,
    RightTable = 1
};

@interface NLItemsListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *leftTable;
@property (weak, nonatomic) IBOutlet UITableView *rightTable;
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftShadowView;
@property (weak, nonatomic) IBOutlet UIImageView *rightShadowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBarHeight;

- (IBAction)back:(id)sender;
- (void)prepareArrays;
- (id)entryForTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath;

@end
