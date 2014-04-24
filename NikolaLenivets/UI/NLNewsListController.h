//
//  NLNewsListController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 24.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLNewsListController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *leftTable;
@property (weak, nonatomic) IBOutlet UITableView *rightTable;

- (IBAction)back:(id)sender;

@end
