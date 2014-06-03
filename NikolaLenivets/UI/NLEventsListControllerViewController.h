//
//  NLEventsListControllerViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLEventGroup.h"
#import "NLItemsListController.h"

@interface NLEventsListControllerViewController : NLItemsListController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithGroup:(NLEventGroup *)group;

@end
